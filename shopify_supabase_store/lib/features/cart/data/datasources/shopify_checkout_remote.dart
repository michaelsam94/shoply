import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/shopify_queries.dart';
import '../../domain/entities/cart_entity.dart';

/// Calls Storefront [cartCreate] so we get a real [checkoutUrl] for hosted checkout.
class ShopifyCheckoutRemote {
  ShopifyCheckoutRemote({
    required this.endpoint,
    required this.storefrontToken,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String endpoint;
  final String storefrontToken;
  final http.Client _client;

  Future<String> createCheckoutUrl(List<CartLineEntity> lines) async {
    if (lines.isEmpty) {
      throw ServerException('Cart is empty');
    }

    final lineInputs = lines
        .map(
          (l) => <String, dynamic>{
            'merchandiseId': l.variantId,
            'quantity': l.quantity,
          },
        )
        .toList();

    final response = await _client.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'X-Shopify-Storefront-Access-Token': storefrontToken,
      },
      body: jsonEncode({
        'query': ShopifyQueries.cartCreate,
        'variables': <String, dynamic>{
          'input': <String, dynamic>{
            'lines': lineInputs,
          },
        },
      }),
    );

    if (response.statusCode != 200) {
      throw ServerException('Shopify request failed', response.statusCode);
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    if (payload['errors'] != null) {
      throw ServerException('Shopify GraphQL errors: ${payload['errors']}');
    }

    final cartCreate =
        payload['data']?['cartCreate'] as Map<String, dynamic>? ?? {};
    final userErrors = cartCreate['userErrors'] as List<dynamic>? ??
        cartCreate['cartUserErrors'] as List<dynamic>? ??
        [];
    if (userErrors.isNotEmpty) {
      final msg = userErrors
          .map((e) => (e as Map<String, dynamic>)['message'] ?? '$e')
          .join('; ');
      throw ServerException(msg);
    }

    final cart = cartCreate['cart'] as Map<String, dynamic>?;
    final url = cart?['checkoutUrl']?.toString().trim() ?? '';
    if (url.isEmpty) {
      throw ServerException('No checkout URL returned from Shopify');
    }
    return url;
  }
}
