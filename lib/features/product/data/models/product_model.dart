import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.title,
    required super.handle,
    required super.description,
    required super.descriptionHtml,
    required super.price,
    required super.currencyCode,
    required super.compareAtPrice,
    required super.images,
    required super.vendor,
    required super.tags,
    required super.variants,
    required super.availableForSale,
  });

  factory ProductModel.fromShopifyNode(Map<String, dynamic> json) {
    final variantsEdges = (json['variants']?['edges'] as List<dynamic>? ?? []);
    final imageEdges = (json['images']?['edges'] as List<dynamic>? ?? []);
    final firstVariantNode = variantsEdges.isNotEmpty
        ? (variantsEdges.first['node'] as Map<String, dynamic>? ?? {})
        : <String, dynamic>{};

    return ProductModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Untitled',
      handle: json['handle']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      descriptionHtml: json['descriptionHtml']?.toString() ?? '',
      price: double.tryParse(
            firstVariantNode['price']?['amount']?.toString() ?? '0',
          ) ??
          0,
      currencyCode:
          firstVariantNode['price']?['currencyCode']?.toString() ?? 'USD',
      compareAtPrice: double.tryParse(
        firstVariantNode['compareAtPrice']?['amount']?.toString() ?? '',
      ),
      images: imageEdges
          .map(
            (e) => (e['node']?['url'] ?? e['node']?['src'] ?? '')
                .toString()
                .trim(),
          )
          .where((url) => url.isNotEmpty)
          .toList(),
      vendor: json['vendor']?.toString() ?? '',
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((tag) => tag.toString())
          .toList(),
      variants: variantsEdges.map((variantEdge) {
        final variant = variantEdge['node'] as Map<String, dynamic>? ?? {};
        return ProductVariantEntity(
          id: variant['id']?.toString() ?? '',
          title: variant['title']?.toString() ?? '',
          price: double.tryParse(variant['price']?['amount']?.toString() ?? '0') ??
              0,
          availableForSale: variant['availableForSale'] == true,
        );
      }).toList(),
      availableForSale: json['availableForSale'] != false,
    );
  }
}
