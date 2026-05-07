import '../../domain/entities/cart_entity.dart';

class CartModel extends CartEntity {
  const CartModel({
    required super.id,
    required super.checkoutUrl,
    required super.lines,
    required super.totalAmount,
    required super.currencyCode,
  });
}
