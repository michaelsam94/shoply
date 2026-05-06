import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_datasource.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  WishlistRepositoryImpl(this._datasource);
  final WishlistDatasource _datasource;

  @override
  Future<Set<String>> getWishlistIds() => _datasource.getWishlistIds();

  @override
  Future<Set<String>> toggle(String productId) => _datasource.toggle(productId);
}
