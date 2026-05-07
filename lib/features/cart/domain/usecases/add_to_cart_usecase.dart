import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class AddToCartUseCase {
  AddToCartUseCase(this._repository);
  final CartRepository _repository;

  Future<CartEntity> call({
    required String variantId,
    required int quantity,
    required String productTitle,
    required String variantTitle,
    required double price,
    required String imageUrl,
  }) {
    return _repository.addItem(
      variantId: variantId,
      quantity: quantity,
      productTitle: productTitle,
      variantTitle: variantTitle,
      price: price,
      imageUrl: imageUrl,
    );
  }
}
