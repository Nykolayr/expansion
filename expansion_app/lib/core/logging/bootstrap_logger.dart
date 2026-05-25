import 'package:flutter/foundation.dart';
import 'package:flutter_easylogger/flutter_logger.dart';

/// Настройка [Logger] из flutter_easylogger: в release лог отключён.
///
/// Компактный вывод: без имени файла и навигации по клику (меньше шума в консоли).
void bootstrapLogger() {
  Logger.init(
    !kReleaseMode,
    isShowTime: true,
    isShowFile: false,
    isShowNavigation: false,
  );
}
