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
import 'package:expansion/presentation/widgets/buttons/game_compact_skew_button.dart';

class BattleTacticalPanel extends StatelessWidget {
  const BattleTacticalPanel({
    required this.base,
    super.key,
  });

  final BattleBase base;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cubit = sl<BattleCubit>();

    return Card(
      color: ExpansionColors.background.withValues(alpha: 0.92),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: ExpansionColors.accent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              loc.battleTacticalTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const Gap(4),
            Text(
              loc.battleTacticalResources(base.resources.round()),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ExpansionColors.accent,
                  ),
            ),
            const Gap(8),
            for (final type in TacticalUpgradeType.values)
              _UpgradeRow(
                label: type.label(loc),
                cost: cubit.tacticalCostFor(base.id, type),
                maxed: base.isTacticalMaxed(type),
                enabled: !base.isTacticalMaxed(type),
                onPressed: () => _onUpgrade(context, type),
              ),
          ],
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

class _UpgradeRow extends StatelessWidget {
  const _UpgradeRow({
    required this.label,
    required this.cost,
    required this.maxed,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final int cost;
  final bool maxed;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          if (maxed)
            Text(loc.battleTacticalMaxLabel)
          else
            GameCompactSkewButton(
              label: loc.battleTacticalBuy(cost),
              onPressed: enabled ? onPressed : null,
              width: 96,
            ),
        ],
      ),
    );
  }
}
