import '../repositories/cart_repository.dart';

class UpdateCartItemUseCase {
  UpdateCartItemUseCase(this._repository);
  final CartRepository _repository;

  Future<void> call({required String lineId, required int quantity}) {
    return _repository.updateLine(lineId: lineId, quantity: quantity);
  }
}
