import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/router/app_router.dart';
import '../../../shared/widgets/tab_page_scaffold.dart';
import '../domain/entities/cart_entity.dart';

import 'providers/cart_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  bool _checkoutBusy = false;

  Future<void> _openCheckout(List<CartLineEntity> lines) async {
    setState(() => _checkoutBusy = true);
    try {
      final url = await ref
          .read(shopifyCheckoutRemoteProvider)
          .createCheckoutUrl(lines);
      if (!mounted) return;
      await context.pushNamed(
        AppRoutes.checkout,
        queryParameters: {'checkoutUrl': url},
      );
    } catch (e) {
      if (!mounted) return;
      final message = e is ServerException ? e.message : '$e';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) setState(() => _checkoutBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartAsync = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);
    final cart = cartAsync.valueOrNull;
    final lines = cart?.lines ?? const [];

    return TabPageScaffold(
      title: 'Cart',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: lines.isEmpty
                ? const Center(child: Text('Cart is empty'))
                : ListView.separated(
                    itemCount: lines.length,
                    padding: const EdgeInsets.all(16),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      final item = lines[index];
                      return ListTile(
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(item.productTitle),
                        subtitle: Text(
                          '\$${item.price.toStringAsFixed(2)} x ${item.quantity}',
                        ),
                        trailing: IconButton(
                          onPressed: () => notifier.removeItem(lineId: item.id),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: FilledButton(
              onPressed: lines.isEmpty || _checkoutBusy
                  ? null
                  : () => _openCheckout(lines),
              child: _checkoutBusy
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Checkout  \$${(cart?.totalAmount ?? 0).toStringAsFixed(2)}',
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
