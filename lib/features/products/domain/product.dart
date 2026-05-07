class Product {
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;

  factory Product.fromShopifyNode(Map<String, dynamic> json) {
    final variantNode = ((json['variants']?['edges'] ?? []) as List).isNotEmpty
        ? (json['variants']['edges'] as List).first['node']
            as Map<String, dynamic>
        : <String, dynamic>{};
    final imageNode = ((json['images']?['edges'] ?? []) as List).isNotEmpty
        ? (json['images']['edges'] as List).first['node']
            as Map<String, dynamic>
        : <String, dynamic>{};
    return Product(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Untitled',
      description: json['description']?.toString() ?? '',
      imageUrl: imageNode['url']?.toString() ?? '',
      price:
          double.tryParse(variantNode['price']?['amount']?.toString() ?? '0') ??
              0,
    );
  }
}
