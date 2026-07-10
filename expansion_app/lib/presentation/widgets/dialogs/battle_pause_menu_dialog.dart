import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';

enum BattlePauseAction {
  continueGame,
  restart,
  exitToMain,
}

/// Меню паузы боя в стиле игры.
Future<BattlePauseAction?> showBattlePauseMenuDialog(BuildContext context) {
  final loc = AppLocalizations.of(context)!;

  return showDialog<BattlePauseAction>(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loc.battlePauseTitle,
                textAlign: TextAlign.center,
                style: ExpansionTextStyles.bodyAccent(ctx, 22),
              ),
              const Gap(20),
              GameLongButton(
                label: loc.battlePauseContinue,
                onPressed: () =>
                    Navigator.of(ctx).pop(BattlePauseAction.continueGame),
              ),
              const Gap(10),
              GameLongButton(
                label: loc.battlePauseRestart,
                onPressed: () =>
                    Navigator.of(ctx).pop(BattlePauseAction.restart),
              ),
              const Gap(10),
              GameLongButton(
                label: loc.battlePauseExitMain,
                onPressed: () =>
                    Navigator.of(ctx).pop(BattlePauseAction.exitToMain),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
