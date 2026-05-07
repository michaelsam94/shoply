import '../logging/app_logger.dart';

@Deprecated('Use AppLogger.exception')
void logAppError(String context, Object error, [StackTrace? stackTrace]) {
  AppLogger.exception(error, stackTrace, context: context);
}
