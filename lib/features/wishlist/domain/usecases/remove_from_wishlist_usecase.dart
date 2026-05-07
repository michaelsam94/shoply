import '../repositories/wishlist_repository.dart';

class RemoveFromWishlistUseCase {
  RemoveFromWishlistUseCase(this.repository);

  final WishlistRepository repository;

  Future<Set<String>> call(String productId) async {
    final current = await repository.getWishlistIds();
    if (!current.contains(productId)) {
      return current;
    }
    return repository.toggle(productId);
  }
}
