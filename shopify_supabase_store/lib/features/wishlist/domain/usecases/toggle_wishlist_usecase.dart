import '../repositories/wishlist_repository.dart';

class ToggleWishlistUseCase {
  ToggleWishlistUseCase(this._repository);
  final WishlistRepository _repository;

  Future<Set<String>> call(String productId) => _repository.toggle(productId);
}
