import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopify_supabase_store/features/cart/presentation/providers/cart_provider.dart';

void main() {
  test('addItem creates cart if none exists', () async {
    final notifier = CartNotifier();
    expect(notifier.state, isA<AsyncData<dynamic>>());
    expect((notifier.state as AsyncData<dynamic>).value, isNull);
    await notifier.addItem(
        variantId: 'gid://shopify/ProductVariant/1', quantity: 1);
    expect((notifier.state as AsyncData<dynamic>).value, isNotNull);
  });

  test('removeItem updates state correctly', () async {
    final notifier = CartNotifier();
    await notifier.addItem(
        variantId: 'gid://shopify/ProductVariant/1', quantity: 1);
    await notifier.removeItem(lineId: 'line-1');
    final cart = (notifier.state as AsyncData<dynamic>).value;
    expect(cart.lines, isEmpty);
  });
}
