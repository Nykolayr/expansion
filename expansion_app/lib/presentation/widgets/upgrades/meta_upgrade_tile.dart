import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/extensions/meta_upgrade_l10n.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/entities/meta_upgrade_slot.dart';
import 'package:expansion/l10n/app_localizations.dart';

class MetaUpgradeTile extends StatelessWidget {
  const MetaUpgradeTile({
    required this.slot,
    required this.score,
    required this.onUpgrade,
    super.key,
  });

  final MetaUpgradeSlot slot;
  final int score;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final canBuy = !slot.isMaxed && score >= slot.nextCost;

    return Card(
      color: ExpansionColors.background.withValues(alpha: 0.92),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: ExpansionColors.accent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot.type.label(loc),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const Gap(4),
                  Text(
                    loc.metaUpgradeLevel(slot.level, slot.percentBonus),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: canBuy ? onUpgrade : null,
              child: Text(
                slot.isMaxed
                    ? loc.metaUpgradeMax
                    : loc.metaUpgradeBuy(slot.nextCost),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
