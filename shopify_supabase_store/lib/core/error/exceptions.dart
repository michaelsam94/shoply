class ServerException implements Exception {
  ServerException(this.message, [this.statusCode]);
  final String message;
  final int? statusCode;
}

class NetworkException implements Exception {
  NetworkException(this.message);
  final String message;
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
}

class CacheException implements Exception {
  CacheException(this.message);
  final String message;
}
