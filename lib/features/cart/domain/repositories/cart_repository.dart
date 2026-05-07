import '../entities/cart_entity.dart';

abstract class CartRepository {
  Future<CartEntity?> getCart();
  Future<CartEntity> addItem({
    required String variantId,
    required int quantity,
    required String productTitle,
    required String variantTitle,
    required double price,
    required String imageUrl,
  });
  Future<void> removeLine(String lineId);
  Future<void> updateLine({required String lineId, required int quantity});
}
