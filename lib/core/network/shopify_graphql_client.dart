import 'package:graphql_flutter/graphql_flutter.dart' hide ServerException;

import '../error/exceptions.dart';

class ShopifyGraphQLClient {
  ShopifyGraphQLClient({
    required String domain,
    required String storefrontAccessToken,
  }) : _client = GraphQLClient(
          cache: GraphQLCache(),
          link: HttpLink(
            'https://$domain/api/2024-01/graphql.json',
            defaultHeaders: {
              'X-Shopify-Storefront-Access-Token': storefrontAccessToken,
              'Content-Type': 'application/json',
            },
          ),
        );

  final GraphQLClient _client;

  Future<QueryResult> query(QueryOptions options) async {
    final result = await _client.query(options);
    if (result.hasException) {
      throw ServerException(result.exception.toString(), null);
    }
    return result;
  }

  Future<QueryResult> mutate(MutationOptions options) async {
    final result = await _client.mutate(options);
    if (result.hasException) {
      throw ServerException(result.exception.toString(), null);
    }
    return result;
  }
}
