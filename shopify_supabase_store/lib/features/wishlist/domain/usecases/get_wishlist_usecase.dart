import '../repositories/wishlist_repository.dart';

class GetWishlistUseCase {
  GetWishlistUseCase(this._repository);
  final WishlistRepository _repository;

  Future<Set<String>> call() => _repository.getWishlistIds();
}
