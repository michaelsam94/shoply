import '../repositories/cart_repository.dart';

class RemoveFromCartUseCase {
  RemoveFromCartUseCase(this._repository);
  final CartRepository _repository;

  Future<void> call(String lineId) => _repository.removeLine(lineId);
}
