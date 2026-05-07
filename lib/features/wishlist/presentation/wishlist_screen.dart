import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/tab_page_scaffold.dart';
import '../../../shared/widgets/product_card.dart';
import '../../products/application/products_notifier.dart';
import '../application/wishlist_notifier.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistProvider);
    final products = ref.watch(productsProvider).valueOrNull ?? const [];
    final wished =
        products.where((item) => wishlist.contains(item.id)).toList();

    return TabPageScaffold(
      title: 'Wishlist',
      body: wished.isEmpty
          ? const Center(child: Text('No wishlist items yet'))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wished.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (_, index) => ProductCard(product: wished[index]),
            ),
    );
  }
}
