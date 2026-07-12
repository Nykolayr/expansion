import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';
import 'package:expansion/presentation/widgets/buttons/game_compact_skew_button.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';

/// Подтверждение действия (сброс кампании и т.п.).
Future<bool> showGameConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  String? cancelLabel,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black54,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        elevation: 10,
        color: ExpansionColors.background.withValues(alpha: 0.96),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: ExpansionColors.accent, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final buttonWidth = constraints.maxWidth;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: ExpansionTextStyles.bodyAccent(ctx, 20),
                  ),
                  const Gap(12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(ctx).textTheme.bodyMedium,
                  ),
                  const Gap(20),
                  GameLongButton(
                    label: confirmLabel,
                    maxWidth: buttonWidth,
                    onPressed: () => Navigator.of(ctx).pop(true),
                  ),
                  if (cancelLabel != null) ...[
                    const Gap(10),
                    Center(
                      child: GameCompactSkewButton(
                        label: cancelLabel,
                        fullWidth: true,
                        maxWidth: buttonWidth,
                        fontSize: 15,
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    ),
  );
  return result ?? false;
}
