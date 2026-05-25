import 'package:flutter/material.dart';
import 'package:expansion/core/themes/app_theme.dart';
import 'package:expansion/core/ui/app_feedback_kind.dart';
import 'package:expansion/core/ui/app_scaffold_messenger_key.dart';

/// Централизованный показ SnackBar (успех / предупреждение / ошибка).
///
/// Регистрируется в GetIt как синглтон; требует [appScaffoldMessengerKey] в [MaterialApp].
class AppFeedbackService {
  static const Duration _duration = Duration(seconds: 4);

  void show(
    String message, {
    AppFeedbackKind kind = AppFeedbackKind.error,
  }) {
    final messenger = appScaffoldMessengerKey.currentState;
    if (messenger == null) return;

    final bg = _background(kind);
    final fg = _foreground(kind);

    messenger
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: fg, fontWeight: FontWeight.w500),
          ),
          backgroundColor: bg,
          behavior: SnackBarBehavior.floating,
          duration: _duration,
        ),
      );
  }

  Color _background(AppFeedbackKind kind) {
    switch (kind) {
      case AppFeedbackKind.success:
        return AppTheme.semanticSuccess;
      case AppFeedbackKind.warning:
        return AppTheme.semanticWarning;
      case AppFeedbackKind.error:
        return AppTheme.semanticError;
    }
  }

  Color _foreground(AppFeedbackKind kind) {
    switch (kind) {
      case AppFeedbackKind.warning:
        return AppTheme.onSemanticWarningText;
      case AppFeedbackKind.success:
      case AppFeedbackKind.error:
        return AppTheme.onSemanticSolid;
    }
  }
}
