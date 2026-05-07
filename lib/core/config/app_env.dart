import 'env.dart';

class AppEnv {
  AppEnv({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.shopifyDomain,
    required this.shopifyStorefrontToken,
  });

  final String supabaseUrl;
  final String supabaseAnonKey;
  final String shopifyDomain;
  final String shopifyStorefrontToken;

  String get shopifyGraphqlEndpoint =>
      'https://$shopifyDomain/api/2024-10/graphql.json';

  /// Same secrets as [Env] (`--dart-define` / `scripts/run_dev.sh`).
  /// Used by providers so we never depend on runtime `.env` loading.
  factory AppEnv.fromDartDefine() {
    return AppEnv(
      supabaseUrl: Env.supabaseUrl,
      supabaseAnonKey: Env.supabaseAnonKey,
      shopifyDomain: Env.shopifyStoreDomain,
      shopifyStorefrontToken: Env.shopifyStorefrontToken,
    );
  }
}
