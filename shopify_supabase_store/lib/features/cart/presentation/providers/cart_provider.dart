import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_providers.dart';
import '../../../product/domain/entities/product_entity.dart';
import '../../../products/domain/product.dart';
import '../../data/datasources/cart_datasource.dart';
import '../../data/datasources/shopify_checkout_remote.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_cart_item_usecase.dart';

final cartDatasourceProvider = Provider<CartDatasource>((_) => CartDatasource());

final shopifyCheckoutRemoteProvider = Provider<ShopifyCheckoutRemote>((ref) {
  final env = ref.watch(appEnvProvider);
  return ShopifyCheckoutRemote(
    endpoint: env.shopifyGraphqlEndpoint,
    storefrontToken: env.shopifyStorefrontToken,
  );
});
final cartRepositoryProvider = Provider<CartRepository>(
  (ref) => CartRepositoryImpl(ref.watch(cartDatasourceProvider)),
);
final getCartUseCaseProvider = Provider<GetCartUseCase>(
  (ref) => GetCartUseCase(ref.watch(cartRepositoryProvider)),
);
final addToCartUseCaseProvider = Provider<AddToCartUseCase>(
  (ref) => AddToCartUseCase(ref.watch(cartRepositoryProvider)),
);
final removeFromCartUseCaseProvider = Provider<RemoveFromCartUseCase>(
  (ref) => RemoveFromCartUseCase(ref.watch(cartRepositoryProvider)),
);
final updateCartItemUseCaseProvider = Provider<UpdateCartItemUseCase>(
  (ref) => UpdateCartItemUseCase(ref.watch(cartRepositoryProvider)),
);

final cartProvider = StateNotifierProvider<CartNotifier, AsyncValue<CartEntity?>>(
  (ref) => CartNotifier(ref),
);

final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider).valueOrNull;
  if (cart == null) return 0;
  return cart.lines.fold(0, (sum, line) => sum + line.quantity);
});

class CartNotifier extends StateNotifier<AsyncValue<CartEntity?>> {
  CartNotifier([this._ref]) : super(const AsyncValue.data(null));
  final Ref? _ref;

  Future<void> initCart() async {
    final ref = _ref;
    if (ref == null) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final cart = await ref.read(getCartUseCaseProvider)();
      return cart;
    });
  }

  Future<void> createCart() async => initCart();

  Future<void> updateItem({required String lineId, required int quantity}) async {
    final ref = _ref;
    if (ref == null) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(updateCartItemUseCaseProvider).call(
            lineId: lineId,
            quantity: quantity,
          );
      return ref.read(getCartUseCaseProvider)();
    });
  }

  Future<void> clearCart() async {
    final ref = _ref;
    if (ref == null) {
      state = const AsyncValue.data(null);
      return;
    }
    final cart = state.valueOrNull;
    if (cart == null) {
      state = const AsyncValue.data(null);
      return;
    }
    for (final line in cart.lines) {
      await ref.read(removeFromCartUseCaseProvider).call(line.id);
    }
    await initCart();
  }

  Future<void> addItem({required String variantId, required int quantity}) async {
    final ref = _ref;
    if (ref == null) {
      final current = state.valueOrNull;
      if (current == null) {
        state = AsyncValue.data(
          CartEntity(
            id: 'local-cart',
            checkoutUrl: '',
            lines: [
              CartLineEntity(
                id: 'line-1',
                quantity: quantity,
                variantId: variantId,
                productTitle: 'Local Product',
                variantTitle: 'Default',
                price: 0,
                imageUrl: '',
              ),
            ],
            totalAmount: 0,
            currencyCode: 'USD',
          ),
        );
      }
      return;
    }
    await ref.read(addToCartUseCaseProvider).call(
          variantId: variantId,
          quantity: quantity,
          productTitle: 'Product',
          variantTitle: 'Default',
          price: 0,
          imageUrl: '',
        );
    await initCart();
  }

  Future<void> removeItem({required String lineId}) async {
    final ref = _ref;
    if (ref == null) {
      final current = state.valueOrNull;
      if (current == null) return;
      state = AsyncValue.data(
        CartEntity(
          id: current.id,
          checkoutUrl: current.checkoutUrl,
          lines: current.lines.where((line) => line.id != lineId).toList(),
          totalAmount: current.totalAmount,
          currencyCode: current.currencyCode,
        ),
      );
      return;
    }
    await ref.read(removeFromCartUseCaseProvider).call(lineId);
    await initCart();
  }

  Future<void> add(Product product) => _addCommon(
        variantId: product.id,
        productTitle: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
      );

  Future<void> addByProductEntity(ProductEntity product) {
    final String variantId;
    if (product.variants.isEmpty) {
      variantId = product.id;
    } else {
      final available = product.variants.where((v) => v.availableForSale);
      variantId = available.isNotEmpty
          ? available.first.id
          : product.variants.first.id;
    }
    return _addCommon(
      variantId: variantId,
      productTitle: product.title,
      price: product.price,
      imageUrl: product.images.isEmpty ? '' : product.images.first,
    );
  }

  Future<void> _addCommon({
    required String variantId,
    required String productTitle,
    required double price,
    required String imageUrl,
  }) async {
    final ref = _ref;
    if (ref == null) return;
    await ref.read(addToCartUseCaseProvider).call(
          variantId: variantId,
          quantity: 1,
          productTitle: productTitle,
          variantTitle: 'Default',
          price: price,
          imageUrl: imageUrl,
        );
    await initCart();
  }
}
