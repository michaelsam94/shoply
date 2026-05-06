import 'package:equatable/equatable.dart';

class WishlistItemEntity extends Equatable {
  const WishlistItemEntity({required this.productId});

  final String productId;

  @override
  List<Object?> get props => [productId];
}
