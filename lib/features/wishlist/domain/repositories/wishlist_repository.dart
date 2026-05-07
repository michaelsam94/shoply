abstract class WishlistRepository {
  Future<Set<String>> getWishlistIds();
  Future<Set<String>> toggle(String productId);
}
