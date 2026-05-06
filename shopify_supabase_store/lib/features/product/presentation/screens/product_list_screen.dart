import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/tab_page_scaffold.dart';
import '../../../../shared/widgets/loading_view.dart';
import '../../../../shared/widgets/product_card.dart';
import '../../presentation/providers/product_provider.dart';
import '../../../products/domain/product.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productListProvider);
    return TabPageScaffold(
      title: 'Products',
      body: products.when(
        data: (items) => RefreshIndicator(
          onRefresh: () => ref.read(productListProvider.notifier).refresh(),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (_, index) {
              final item = items[index];
              final uiProduct = Product(
                id: item.id,
                title: item.title,
                description: item.description,
                imageUrl: item.images.isEmpty ? '' : item.images.first,
                price: item.price,
              );
              return ProductCard(product: uiProduct);
            },
          ),
        ),
        error: (error, _) => Center(child: Text('Failed to load: $error')),
        loading: LoadingView.new,
      ),
    );
  }
}
