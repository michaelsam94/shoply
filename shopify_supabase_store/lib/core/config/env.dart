class Env {
  static const shopifyStoreDomain = String.fromEnvironment('SHOPIFY_DOMAIN');
  static const shopifyStorefrontToken =
      String.fromEnvironment('SHOPIFY_STOREFRONT_TOKEN');
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Optional. Used as GoTrue `redirect_to` for signup confirmation & password reset.
  /// Must be listed under Supabase → Authentication → URL Configuration → Redirect URLs.
  static const supabaseEmailRedirect =
      String.fromEnvironment('SUPABASE_EMAIL_REDIRECT');

  /// Compile-time flags from `--dart-define` / `scripts/run_dev.sh`.
  /// If false, [supabaseUrl] and [supabaseAnonKey] are empty strings.
  static bool get hasSupabaseConfig =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// True when `.env.example` placeholders were baked in (DNS will fail).
  static bool get hasPlaceholderSupabaseValues {
    final url = supabaseUrl.toLowerCase();
    final key = supabaseAnonKey.toLowerCase();
    return url.contains('your-project.supabase.co') ||
        url.contains('placeholder') ||
        key == 'your_anon_key' ||
        key.contains('your_anon');
  }
}
