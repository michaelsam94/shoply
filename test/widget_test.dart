import 'package:flutter_test/flutter_test.dart';

import 'package:shopify_supabase_store/core/config/cache_config.dart';

void main() {
  test('cache config has valid ttl values', () {
    expect(CacheConfig.homeProductsCacheTtl.inMinutes, greaterThan(0));
    expect(CacheConfig.productDetailsCacheTtl.inMinutes, greaterThan(0));
  });
}
