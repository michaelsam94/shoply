import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/tab_page_scaffold.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../features/products/application/products_notifier.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    final crossAxis = Responsive.value(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );

    return TabPageScaffold(
      title: 'Shoply',
      body: products.when(
        data: (items) => RefreshIndicator(
          onRefresh: () =>
              ref.read(productsProvider.notifier).refreshProducts(),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxis,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemBuilder: (_, index) => ProductCard(product: items[index]),
          ),
        ),
        error: (error, _) =>
            Center(child: Text('Failed to load products: $error')),
        loading: LoadingView.new,
      ),
    );
  }
}
