import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_logger.dart';

/// Logs every Riverpod provider failure (init throw, async error, stream error).
class RiverpodExceptionObserver extends ProviderObserver {
  const RiverpodExceptionObserver();

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    AppLogger.exception(
      error,
      stackTrace,
      context: 'Riverpod:${provider.toString()}',
    );
  }
}
