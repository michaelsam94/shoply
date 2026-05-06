import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Single place for logging [Exception]s and [Error]s (terminal, DevTools, crash tooling hooks).
///
/// Call [installFrameworkHooks] once after [WidgetsFlutterBinding.ensureInitialized].
abstract final class AppLogger {
  static bool _frameworkHooksInstalled = false;

  /// Wires [FlutterError.onError] and [PlatformDispatcher.onError] to [exception].
  static void installFrameworkHooks() {
    if (_frameworkHooksInstalled) {
      return;
    }
    _frameworkHooksInstalled = true;

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      exception(
        details.exception,
        details.stack,
        context: 'FlutterError',
      );
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      exception(error, stack, context: 'PlatformDispatcher');
      return true;
    };
  }

  /// Log any thrown value (typically from `catch (e, st)`).
  static void exception(
    Object error,
    StackTrace? stackTrace, {
    String? context,
  }) {
    final label = context ?? 'Exception';
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('[$label] $error');
    if (stackTrace != null) {
      debugPrintStack(stackTrace: stackTrace, label: '[$label]');
    }
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    developer.log(
      error.toString(),
      name: label,
      stackTrace: stackTrace,
      level: 1000,
      error: error is Error ? error : null,
    );
  }

  /// Non-fatal diagnostics (optional).
  static void warn(String message, {String? context}) {
    final label = context ?? 'Warn';
    debugPrint('[$label] $message');
    developer.log(message, name: label, level: 900);
  }
}
