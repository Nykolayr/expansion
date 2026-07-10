import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';

/// Пауза и подсказка при первом метеорите в миссии.
class BattleMeteoriteTutorial extends StatelessWidget {
  const BattleMeteoriteTutorial({
    required this.onDismiss,
    super.key,
  });

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Material(
      color: Colors.black.withValues(alpha: 0.72),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(),
              Icon(
                Icons.arrow_downward_rounded,
                size: 48,
                color: ExpansionColors.accent.withValues(alpha: 0.9),
              ),
              const Gap(12),
              Text(
                loc.battleMeteoriteTutorialTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: ExpansionColors.accent,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const Gap(12),
              Text(
                loc.battleMeteoriteTutorialBody,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: ExpansionColors.white,
                      height: 1.35,
                    ),
              ),
              const Spacer(),
              GameLongButton(
                label: loc.battleMeteoriteTutorialDismiss,
                onPressed: onDismiss,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
