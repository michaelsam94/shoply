import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/app_providers.dart';
import '../domain/product.dart';

final shopifyDatasourceProvider = Provider<ShopifyProductsDatasource>((ref) {
  final env = ref.watch(appEnvProvider);
  return ShopifyProductsDatasource(
    endpoint: env.shopifyGraphqlEndpoint,
    storefrontToken: env.shopifyStorefrontToken,
  );
});

class ShopifyProductsDatasource {
  ShopifyProductsDatasource({
    required this.endpoint,
    required this.storefrontToken,
  });

  final String endpoint;
  final String storefrontToken;

  Future<List<Product>> fetchProducts() async {
    const query = r'''
      query ProductsList {
        products(first: 20) {
          edges {
            node {
              id
              title
              description
              images(first: 1) { edges { node { url } } }
              variants(first: 1) { edges { node { price { amount } } } }
            }
          }
        }
      }
    ''';

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'X-Shopify-Storefront-Access-Token': storefrontToken,
      },
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Shopify products request failed (${response.statusCode})',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['errors'] != null) {
      throw Exception('Shopify GraphQL error: ${data['errors']}');
    }

    final edges = (data['data']?['products']?['edges'] ?? []) as List<dynamic>;
    return edges
        .map(
          (edge) =>
              Product.fromShopifyNode(edge['node'] as Map<String, dynamic>),
        )
        .toList();
  }
}
