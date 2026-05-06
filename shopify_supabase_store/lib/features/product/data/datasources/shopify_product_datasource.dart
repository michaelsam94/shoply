import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/shopify_queries.dart';
import '../models/product_model.dart';

class ShopifyProductDatasource {
  ShopifyProductDatasource({
    required this.endpoint,
    required this.storefrontToken,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String endpoint;
  final String storefrontToken;
  final http.Client _client;

  Future<(List<ProductModel> products, bool hasNextPage, String? cursor)>
      getProducts({
    String? cursor,
    String? query,
    int first = 20,
  }) async {
    final response = await _client.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'X-Shopify-Storefront-Access-Token': storefrontToken,
      },
      body: jsonEncode({
        'query': ShopifyQueries.getProducts,
        'variables': {'first': first, 'after': cursor, 'query': query},
      }),
    );

    if (response.statusCode != 200) {
      throw ServerException(
        'Shopify request failed',
        response.statusCode,
      );
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    if (payload['errors'] != null) {
      throw ServerException('Shopify GraphQL errors: ${payload['errors']}');
    }

    final productData = payload['data']?['products'] as Map<String, dynamic>? ?? {};
    final edges = (productData['edges'] as List<dynamic>? ?? []);
    final pageInfo = productData['pageInfo'] as Map<String, dynamic>? ?? {};
    return (
      edges
          .map((edge) => ProductModel.fromShopifyNode(edge['node'] as Map<String, dynamic>))
          .toList(),
      pageInfo['hasNextPage'] == true,
      pageInfo['endCursor']?.toString(),
    );
  }

  Future<ProductModel> getProductById(String id) async {
    final response = await _client.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'X-Shopify-Storefront-Access-Token': storefrontToken,
      },
      body: jsonEncode({
        'query': ShopifyQueries.getProductById,
        'variables': {'id': id},
      }),
    );

    if (response.statusCode != 200) {
      throw ServerException(
        'Shopify request failed',
        response.statusCode,
      );
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    if (payload['errors'] != null) {
      throw ServerException('Shopify GraphQL errors: ${payload['errors']}');
    }

    final node = payload['data']?['product'] as Map<String, dynamic>?;
    if (node == null) {
      throw ServerException('Product not found');
    }

    return ProductModel.fromShopifyNode(node);
  }
}
