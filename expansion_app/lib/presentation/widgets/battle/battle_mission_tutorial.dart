import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/battle/battle_state.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';

/// Плашка туториала миссии 1 — поверх поля, не сжимает сетку.
class BattleMissionTutorial extends StatelessWidget {
  const BattleMissionTutorial({
    required this.step,
    required this.onSkip,
    required this.onDismissUpgrade,
    required this.onDismissGoal,
    this.prominent = false,
    super.key,
  });

  final MissionTutorialStep step;
  final VoidCallback onSkip;
  final VoidCallback onDismissUpgrade;
  final VoidCallback onDismissGoal;

  /// Финальный шаг — затемнение и карточка по центру, чтобы не пропустить.
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    if (step == MissionTutorialStep.none) return const SizedBox.shrink();

    final loc = AppLocalizations.of(context)!;

    final (title, body, showDismiss, onDismiss) = switch (step) {
      MissionTutorialStep.drag => (
          loc.battleTutorialDragTitle,
          loc.battleTutorialDragBody,
          false,
          null,
        ),
      MissionTutorialStep.captureHint => (
          loc.battleTutorialCaptureTitle,
          loc.battleTutorialCaptureBody,
          false,
          null,
        ),
      MissionTutorialStep.upgradeOverlay => (
          loc.battleTutorialUpgradeTitle,
          loc.battleTutorialUpgradeBody,
          true,
          onDismissUpgrade,
        ),
      MissionTutorialStep.goalOverlay => (
          loc.battleTutorialGoalTitle,
          loc.battleTutorialGoalBody,
          true,
          onDismissGoal,
        ),
      MissionTutorialStep.none => ('', '', false, null),
    };

    final card = _TutorialCard(
      title: title,
      body: body,
      showDismiss: showDismiss,
      onDismiss: onDismiss,
      showSkip: step != MissionTutorialStep.goalOverlay,
      skipLabel: loc.battleTutorialSkip,
      dismissLabel: loc.battleTutorialDismiss,
      onSkip: onSkip,
    );

    if (prominent) {
      return Stack(
        fit: StackFit.expand,
        children: [
          ModalBarrier(
            color: Colors.black.withValues(alpha: 0.55),
            dismissible: false,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: card,
            ),
          ),
        ],
      );
    }

    return card;
  }
}

class _TutorialCard extends StatelessWidget {
  const _TutorialCard({
    required this.title,
    required this.body,
    required this.showDismiss,
    required this.onDismiss,
    required this.showSkip,
    required this.skipLabel,
    required this.dismissLabel,
    required this.onSkip,
  });

  final String title;
  final String body;
  final bool showDismiss;
  final VoidCallback? onDismiss;
  final bool showSkip;
  final String skipLabel;
  final String dismissLabel;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: ExpansionColors.background.withValues(alpha: 0.98),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 8, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ExpansionColors.accent,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const Gap(6),
            Text(
              body,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (showSkip) ...[
              const Gap(12),
              GameLongButton(
                label: skipLabel,
                fontSize: 16,
                onPressed: onSkip,
              ),
            ],
            if (showDismiss && onDismiss != null) ...[
              const Gap(12),
              GameLongButton(
                label: dismissLabel,
                onPressed: onDismiss,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
