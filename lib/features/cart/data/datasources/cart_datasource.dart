import '../../domain/entities/cart_entity.dart';

class CartDatasource {
  CartEntity? _cart;

  Future<CartEntity?> getCart() async => _cart;

  Future<CartEntity> addItem({
    required String variantId,
    required int quantity,
    required String productTitle,
    required String variantTitle,
    required double price,
    required String imageUrl,
  }) async {
    final current = _cart ??
        const CartEntity(
          id: 'local-cart',
          checkoutUrl: '',
          lines: <CartLineEntity>[],
          totalAmount: 0,
          currencyCode: 'USD',
        );
    final existingIndex =
        current.lines.indexWhere((line) => line.variantId == variantId);
    final updatedLines = [...current.lines];
    if (existingIndex == -1) {
      updatedLines.add(
        CartLineEntity(
          id: '${variantId}_${DateTime.now().millisecondsSinceEpoch}',
          quantity: quantity,
          variantId: variantId,
          productTitle: productTitle,
          variantTitle: variantTitle,
          price: price,
          imageUrl: imageUrl,
        ),
      );
    } else {
      final existing = updatedLines[existingIndex];
      updatedLines[existingIndex] = CartLineEntity(
        id: existing.id,
        quantity: existing.quantity + quantity,
        variantId: existing.variantId,
        productTitle: existing.productTitle,
        variantTitle: existing.variantTitle,
        price: existing.price,
        imageUrl: existing.imageUrl,
      );
    }
    final total = updatedLines.fold<double>(
        0, (sum, line) => sum + (line.price * line.quantity));
    _cart = CartEntity(
      id: current.id,
      checkoutUrl: current.checkoutUrl,
      lines: updatedLines,
      totalAmount: total,
      currencyCode: current.currencyCode,
    );
    return _cart!;
  }

  Future<void> removeLine(String lineId) async {
    final current = _cart;
    if (current == null) return;
    final updatedLines =
        current.lines.where((line) => line.id != lineId).toList();
    final total = updatedLines.fold<double>(
        0, (sum, line) => sum + (line.price * line.quantity));
    _cart = CartEntity(
      id: current.id,
      checkoutUrl: current.checkoutUrl,
      lines: updatedLines,
      totalAmount: total,
      currencyCode: current.currencyCode,
    );
  }

  Future<void> updateLine(
      {required String lineId, required int quantity}) async {
    final current = _cart;
    if (current == null) return;
    final updatedLines = current.lines
        .map((line) {
          if (line.id != lineId) return line;
          return CartLineEntity(
            id: line.id,
            quantity: quantity,
            variantId: line.variantId,
            productTitle: line.productTitle,
            variantTitle: line.variantTitle,
            price: line.price,
            imageUrl: line.imageUrl,
          );
        })
        .where((line) => line.quantity > 0)
        .toList();
    final total = updatedLines.fold<double>(
        0, (sum, line) => sum + (line.price * line.quantity));
    _cart = CartEntity(
      id: current.id,
      checkoutUrl: current.checkoutUrl,
      lines: updatedLines,
      totalAmount: total,
      currencyCode: current.currencyCode,
    );
  }
}
