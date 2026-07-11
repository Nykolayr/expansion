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
    final triangleColor = slot.isMaxed
        ? ExpansionColors.grey
        : canBuy
            ? Colors.amber
            : ExpansionColors.grey;

    return Card(
      color: ExpansionColors.background.withValues(alpha: 0.92),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: ExpansionColors.accent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    slot.type.label(loc),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: ExpansionColors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                  ),
                  const Gap(6),
                  _LevelRow(slot: slot, canBuy: canBuy, loc: loc),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _UpgradeAction(
              cost: slot.nextCost,
              maxed: slot.isMaxed,
              canBuy: canBuy,
              triangleColor: triangleColor,
              maxLabel: loc.metaUpgradeMax,
              onUpgrade: onUpgrade,
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelRow extends StatelessWidget {
  const _LevelRow({
    required this.slot,
    required this.canBuy,
    required this.loc,
  });

  final MetaUpgradeSlot slot;
  final bool canBuy;
  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
          color: slot.isMaxed || !canBuy
              ? ExpansionColors.grey
              : ExpansionColors.white,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        );

    if (slot.isMaxed) {
      return Text(
        '${loc.metaUpgradeLevel(slot.level, slot.percentBonus)} · ${loc.metaUpgradeMax}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: baseStyle,
      );
    }

    final nextLevel = slot.level + 1;
    final nextPercent = slot.percentBonus + slot.stepPercent;

    return Text.rich(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: loc.metaUpgradeLevel(slot.level, slot.percentBonus)),
          const TextSpan(text: ' → '),
          TextSpan(
            text: loc.metaUpgradeLevel(nextLevel, nextPercent),
            style: baseStyle?.copyWith(color: Colors.amber),
          ),
        ],
      ),
    );
  }
}

class _UpgradeAction extends StatelessWidget {
  const _UpgradeAction({
    required this.cost,
    required this.maxed,
    required this.canBuy,
    required this.triangleColor,
    required this.maxLabel,
    required this.onUpgrade,
  });

  final int cost;
  final bool maxed;
  final bool canBuy;
  final Color triangleColor;
  final String maxLabel;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final costColor =
        maxed || !canBuy ? ExpansionColors.grey : ExpansionColors.accent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canBuy ? onUpgrade : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(
                scaleX: 1.45,
                child: Text(
                  '▲',
                  style: TextStyle(
                    color: triangleColor,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                    height: 1,
                    shadows: canBuy
                        ? const [
                            Shadow(color: Colors.black87, blurRadius: 2),
                          ]
                        : null,
                  ),
                ),
              ),
              const Gap(2),
              Text(
                maxed ? maxLabel : '$cost',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: costColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
