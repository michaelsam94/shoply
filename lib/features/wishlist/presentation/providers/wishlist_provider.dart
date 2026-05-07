import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/wishlist_datasource.dart';
import '../../data/repositories/wishlist_repository_impl.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../../domain/usecases/get_wishlist_usecase.dart';
import '../../domain/usecases/toggle_wishlist_usecase.dart';

final wishlistDatasourceProvider = Provider<WishlistDatasource>(
  (_) => WishlistDatasource(),
);
final wishlistRepositoryProvider = Provider<WishlistRepository>(
  (ref) => WishlistRepositoryImpl(ref.watch(wishlistDatasourceProvider)),
);
final getWishlistUseCaseProvider = Provider<GetWishlistUseCase>(
  (ref) => GetWishlistUseCase(ref.watch(wishlistRepositoryProvider)),
);
final toggleWishlistUseCaseProvider = Provider<ToggleWishlistUseCase>(
  (ref) => ToggleWishlistUseCase(ref.watch(wishlistRepositoryProvider)),
);

final wishlistProvider = NotifierProvider<WishlistNotifier, Set<String>>(
  WishlistNotifier.new,
);

class WishlistNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  Future<void> load() async {
    state = await ref.read(getWishlistUseCaseProvider).call();
  }

  Future<void> toggle(String productId) async {
    state = await ref.read(toggleWishlistUseCaseProvider).call(productId);
  }
}
