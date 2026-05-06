class WishlistDatasource {
  final Set<String> _ids = <String>{};

  Future<Set<String>> getWishlistIds() async => {..._ids};

  Future<Set<String>> toggle(String productId) async {
    if (!_ids.add(productId)) {
      _ids.remove(productId);
    }
    return {..._ids};
  }
}
