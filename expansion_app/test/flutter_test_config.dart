import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Инициализация sqflite для unit/widget-тестов на desktop/CI.
Future<void> testExecutable(Future<void> Function() testMain) async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  await testMain();
}
