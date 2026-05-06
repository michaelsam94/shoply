class CacheConfig {
  static const cartCacheKey = 'cache.cart.items';
  static const wishlistCacheKey = 'cache.wishlist.ids';
  static const homeProductsCacheTtl = Duration(minutes: 15);
  static const productDetailsCacheTtl = Duration(minutes: 20);
}
