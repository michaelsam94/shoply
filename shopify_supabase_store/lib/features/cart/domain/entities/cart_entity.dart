import 'package:equatable/equatable.dart';

class CartLineEntity extends Equatable {
  const CartLineEntity({
    required this.id,
    required this.quantity,
    required this.variantId,
    required this.productTitle,
    required this.variantTitle,
    required this.price,
    required this.imageUrl,
  });
  final String id;
  final int quantity;
  final String variantId;
  final String productTitle;
  final String variantTitle;
  final double price;
  final String imageUrl;
  @override
  List<Object?> get props => [id, quantity];
}

class CartEntity extends Equatable {
  const CartEntity({
    required this.id,
    required this.checkoutUrl,
    required this.lines,
    required this.totalAmount,
    required this.currencyCode,
  });
  final String id;
  final String checkoutUrl;
  final List<CartLineEntity> lines;
  final double totalAmount;
  final String currencyCode;
  @override
  List<Object?> get props => [id, lines, totalAmount, currencyCode];
}
