import 'package:equatable/equatable.dart';

class ProductVariantEntity extends Equatable {
  const ProductVariantEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.availableForSale,
  });
  final String id;
  final String title;
  final double price;
  final bool availableForSale;
  @override
  List<Object?> get props => [id, title, price, availableForSale];
}

class CollectionEntity extends Equatable {
  const CollectionEntity({
    required this.id,
    required this.title,
    required this.handle,
    required this.imageUrl,
    required this.description,
  });
  final String id;
  final String title;
  final String handle;
  final String imageUrl;
  final String description;
  @override
  List<Object?> get props => [id, title, handle, imageUrl, description];
}

class ProductEntity extends Equatable {
  const ProductEntity({
    required this.id,
    required this.title,
    required this.handle,
    required this.description,
    required this.descriptionHtml,
    required this.price,
    required this.currencyCode,
    required this.compareAtPrice,
    required this.images,
    required this.vendor,
    required this.tags,
    required this.variants,
    required this.availableForSale,
  });
  final String id;
  final String title;
  final String handle;
  final String description;
  final String descriptionHtml;
  final double price;
  final String currencyCode;
  final double? compareAtPrice;
  final List<String> images;
  final String vendor;
  final List<String> tags;
  final List<ProductVariantEntity> variants;
  final bool availableForSale;
  @override
  List<Object?> get props => [id, title, handle];
}
