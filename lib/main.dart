import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/env.dart';
import 'core/config/missing_env_app.dart' show MissingEnvApp, PlaceholderSupabaseApp;
import 'core/logging/app_logger.dart';
import 'core/logging/riverpod_exception_observer.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    AppLogger.installFrameworkHooks();

    if (!Env.hasSupabaseConfig) {
      runApp(const MissingEnvApp());
      return;
    }

    if (Env.hasPlaceholderSupabaseValues) {
      runApp(const PlaceholderSupabaseApp());
      return;
    }

    await Supabase.initialize(
      url: Env.supabaseUrl,
      anonKey: Env.supabaseAnonKey,
      debug: kDebugMode,
    );
    await Hive.initFlutter();
    runApp(
      const ProviderScope(
        observers: [RiverpodExceptionObserver()],
        child: App(),
      ),
    );
  }, (Object error, StackTrace stack) {
    AppLogger.exception(error, stack, context: 'UncaughtZone');
  });
}
