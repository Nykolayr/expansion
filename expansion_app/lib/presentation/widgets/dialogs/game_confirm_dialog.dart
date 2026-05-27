import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';

/// Подтверждение действия (сброс кампании и т.п.).
Future<bool> showGameConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required String cancelLabel,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      backgroundColor: ExpansionColors.background.withValues(alpha: 0.95),
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(message),
          const Gap(20),
          GameLongButton(
            label: confirmLabel,
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
          const Gap(8),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(cancelLabel),
          ),
        ],
      ),
    ),
  );
  return result ?? false;
}
