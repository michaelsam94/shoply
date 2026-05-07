import '../error/failures.dart';

String mapFailureToMessage(Failure failure) {
  return switch (failure) {
    ServerFailure() => 'Server error. Please try again.',
    NetworkFailure() => 'No internet connection.',
    AuthFailure() => failure.message,
    CacheFailure() => 'Cache error. Please restart the app.',
    _ => 'Unexpected error occurred.',
  };
}
