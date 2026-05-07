import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class CreateCartUseCase {
  CreateCartUseCase(this.repository);

  final CartRepository repository;

  Future<CartEntity> call() {
    return repository.addItem(
      variantId: 'bootstrap-variant',
      quantity: 1,
      productTitle: 'Starter Item',
      variantTitle: 'Default',
      price: 0,
      imageUrl: '',
    );
  }
}
