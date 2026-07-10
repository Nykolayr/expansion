import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/extensions/tactical_upgrade_l10n.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/ui/app_feedback_kind.dart';
import 'package:expansion/core/ui/app_feedback_service.dart';
import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/enums/tactical_upgrade_type.dart';
import 'package:expansion/game_core/battle/tactical_upgrade_result.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/bloc/battle/battle_cubit.dart';
import 'package:expansion/presentation/widgets/battle/battle_upgrade_triangle_button.dart';

/// Компактная панель базы внизу экрана боя.
class BattleTacticalBar extends StatelessWidget {
  const BattleTacticalBar({
    required this.base,
    required this.onClose,
    super.key,
  });

  final BattleBase base;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cubit = sl<BattleCubit>();

    return Material(
      color: ExpansionColors.background.withValues(alpha: 0.94),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      loc.battleBaseSummary(
                        base.ships,
                        base.shield.round(),
                        base.resources.round(),
                      ),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: ExpansionColors.accent,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: ExpansionColors.accent),
                    onPressed: onClose,
                    tooltip: loc.battleTacticalClose,
                  ),
                ],
              ),
              Row(
                children: [
                  for (final type in TacticalUpgradeType.values)
                    Builder(
                      builder: (context) {
                        final preview = cubit.tacticalPreview(type);
                        if (preview == null) return const SizedBox.shrink();
                        final canAfford = base.resources >= preview.cost;
                        return BattleUpgradeTriangleButton(
                          label: type.shortLabel(loc),
                          currentValue: preview.current,
                          nextValue: preview.next,
                          cost: preview.cost,
                          maxed: preview.maxed,
                          canAfford: canAfford,
                          enabled: !preview.maxed,
                          onPressed: () => _onUpgrade(context, type),
                        );
                      },
                    ),
                ],
              ),
              const Gap(2),
            ],
          ),
        ),
      ),
    );
  }

  void _onUpgrade(BuildContext context, TacticalUpgradeType type) {
    final loc = AppLocalizations.of(context)!;
    final result = sl<BattleCubit>().purchaseTacticalUpgrade(type);
    if (result == null) return;

    final feedback = sl<AppFeedbackService>();
    switch (result) {
      case TacticalUpgradeResult.success:
        break;
      case TacticalUpgradeResult.notEnoughResources:
        feedback.show(loc.battleTacticalNotEnough, kind: AppFeedbackKind.warning);
      case TacticalUpgradeResult.maxLevel:
        feedback.show(loc.battleTacticalMax, kind: AppFeedbackKind.warning);
      case TacticalUpgradeResult.busy:
      case TacticalUpgradeResult.invalidBase:
      case TacticalUpgradeResult.notPlayerBase:
        break;
    }
  }
}
