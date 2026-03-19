import 'package:flutter/foundation.dart';

/// Lightweight logger that auto-disables in release builds.
///
/// Usage: Logger.info('message', tag: 'Component');
/// All output goes through debugPrint (which throttles to avoid
/// dropped lines on Android) and is compiled out in release mode
/// via the kReleaseMode check.
class Logger {
  Logger._();

  static void info(String message, {String? tag}) {
    if (!kReleaseMode) {
      debugPrint('${_prefix(tag)}$message');
    }
  }

  static void warning(String message, {String? tag}) {
    if (!kReleaseMode) {
      debugPrint('WARN ${_prefix(tag)}$message');
    }
  }

  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kReleaseMode) {
      debugPrint('ERROR ${_prefix(tag)}$message');
      if (error != null) debugPrint('  Error: $error');
      if (stackTrace != null) debugPrint('  Stack: $stackTrace');
    }
  }

  static String _prefix(String? tag) => tag != null ? '[$tag] ' : '';
}
