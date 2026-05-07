import 'package:flutter_test/flutter_test.dart';
import 'package:shopify_supabase_store/features/products/domain/product.dart';

void main() {
  test('product parser reads basic values', () {
    final product = Product.fromShopifyNode({
      'id': 'gid://shopify/Product/1',
      'title': 'Sneaker',
      'description': 'Lightweight running shoe',
      'images': {
        'edges': [
          {
            'node': {'url': 'https://cdn.example.com/sneaker.jpg'},
          },
        ],
      },
      'variants': {
        'edges': [
          {
            'node': {
              'price': {'amount': '149.99'},
            },
          },
        ],
      },
    });

    expect(product.title, 'Sneaker');
    expect(product.price, 149.99);
    expect(product.imageUrl, contains('sneaker.jpg'));
  });
}
