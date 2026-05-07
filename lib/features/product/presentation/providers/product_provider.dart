import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/app_providers.dart';
import '../../data/datasources/shopify_product_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_products_usecase.dart';

final shopifyProductDatasourceProvider = Provider<ShopifyProductDatasource>((
  ref,
) {
  final env = ref.watch(appEnvProvider);
  return ShopifyProductDatasource(
    endpoint: env.shopifyGraphqlEndpoint,
    storefrontToken: env.shopifyStorefrontToken,
  );
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(ref.watch(shopifyProductDatasourceProvider));
});

final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  return GetProductsUseCase(ref.watch(productRepositoryProvider));
});

final productListProvider =
    AsyncNotifierProvider<ProductListNotifier, List<ProductEntity>>(
  ProductListNotifier.new,
);

final productDetailProvider =
    FutureProvider.family<ProductEntity, String>((ref, id) async {
  final result = await ref.watch(productRepositoryProvider).getProductById(id);
  return result.fold((failure) => throw Exception(failure.message), (p) => p);
});

class ProductListNotifier extends AsyncNotifier<List<ProductEntity>> {
  @override
  Future<List<ProductEntity>> build() async {
    final result = await ref.read(getProductsUseCaseProvider).call();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (data) => data.$1,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}
