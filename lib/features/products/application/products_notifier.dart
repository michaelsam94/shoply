import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/shopify_products_datasource.dart';
import '../domain/product.dart';

final productsProvider = AsyncNotifierProvider<ProductsNotifier, List<Product>>(
  ProductsNotifier.new,
);

final productByIdProvider = Provider.family<Product?, String>((ref, id) {
  final products = ref.watch(productsProvider).valueOrNull ?? const <Product>[];
  for (final product in products) {
    if (product.id == id) return product;
  }
  return null;
});

class ProductsNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    return ref.read(shopifyDatasourceProvider).fetchProducts();
  }

  Future<void> refreshProducts() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(shopifyDatasourceProvider).fetchProducts(),
    );
  }
}
