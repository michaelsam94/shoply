import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_datasource.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(this._datasource);

  final CartDatasource _datasource;

  @override
  Future<CartEntity> addItem({
    required String variantId,
    required int quantity,
    required String productTitle,
    required String variantTitle,
    required double price,
    required String imageUrl,
  }) {
    return _datasource.addItem(
      variantId: variantId,
      quantity: quantity,
      productTitle: productTitle,
      variantTitle: variantTitle,
      price: price,
      imageUrl: imageUrl,
    );
  }

  @override
  Future<CartEntity?> getCart() => _datasource.getCart();

  @override
  Future<void> removeLine(String lineId) => _datasource.removeLine(lineId);

  @override
  Future<void> updateLine({required String lineId, required int quantity}) {
    return _datasource.updateLine(lineId: lineId, quantity: quantity);
  }
}
