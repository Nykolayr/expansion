import 'package:flutter/services.dart';

/// Лёгкая тактильная отдача.
abstract final class GameHaptic {
  static void light() => HapticFeedback.lightImpact();

  static void success() => HapticFeedback.mediumImpact();

  static void warning() => HapticFeedback.heavyImpact();
}
