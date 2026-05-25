import 'package:flutter/foundation.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:logger/logger.dart' as le;

/// Единая точка логирования: ошибки — [Logger] (easylogger), остальное — компактный [le.Logger].
abstract final class AppLog {
  static final le.Logger _trace = le.Logger(
    level: kReleaseMode ? le.Level.off : le.Level.debug,
    filter: le.ProductionFilter(),
    printer: le.SimplePrinter(colors: false, printTime: false),
  );

  /// Короткие отладочные сообщения (в release отключено).
  static void trace(String message, {String? tag}) {
    final line = tag != null ? '[$tag] $message' : message;
    _trace.d(line);
  }

  /// Ошибки, сбои, `catch` в data/domain — через easylogger.
  static void error(
    Object? message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final b = StringBuffer(message ?? 'Error');
    if (error != null) {
      b.write(' | $error');
    }
    if (stackTrace != null) {
      b.write('\n$stackTrace');
    }
    Logger.e(b.toString(), tag: tag);
  }
}
