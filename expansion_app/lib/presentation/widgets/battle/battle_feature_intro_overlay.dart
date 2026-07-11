import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/constants/battle_assets.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/enums/mission_feature_intro.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/widgets/battle/battle_entity_sprite.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';

/// Онбординг новой механики в начале миссии (пауза боя).
class BattleFeatureIntroOverlay extends StatelessWidget {
  const BattleFeatureIntroOverlay({
    required this.feature,
    required this.onDismiss,
    super.key,
  });

  final MissionFeatureIntro feature;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final (title, body, assetPath, scale) = switch (feature) {
      MissionFeatureIntro.mediumBase => (
          loc.battleIntroMediumBaseTitle,
          loc.battleIntroMediumBaseBody,
          BattleAssets.neutralMiddle,
          1.0,
        ),
      MissionFeatureIntro.largeBase => (
          loc.battleIntroLargeBaseTitle,
          loc.battleIntroLargeBaseBody,
          BattleAssets.neutralLarge,
          1.0,
        ),
    };

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
            child: Material(
              elevation: 8,
              color: ExpansionColors.background.withValues(alpha: 0.98),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BattleEntitySprite(
                      assetPath: assetPath,
                      size: 72 * scale,
                    ),
                    const Gap(12),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ExpansionColors.accent,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const Gap(8),
                    Text(
                      body,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Gap(16),
                    GameLongButton(
                      label: loc.battleTutorialDismiss,
                      onPressed: onDismiss,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
