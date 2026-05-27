import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/l10n/app_localizations.dart';

/// Панель над полем боя (не сжимает сетку), закрытие свайпом вниз или кнопкой.
class BattleBaseOverlayPanel extends StatelessWidget {
  const BattleBaseOverlayPanel({
    required this.onClose,
    required this.child,
    super.key,
  });

  final VoidCallback onClose;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Dismissible(
      key: const ValueKey('battle_base_overlay'),
      direction: DismissDirection.down,
      onDismissed: (_) => onClose(),
      child: Material(
        color: Colors.transparent,
        child: Card(
          margin: EdgeInsets.zero,
          color: ExpansionColors.background.withValues(alpha: 0.94),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: ExpansionColors.accent, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 4, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        loc.battleTacticalSwipeHint,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: ExpansionColors.grey,
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
              ),
              child,
              const Gap(4),
            ],
          ),
        ),
      ),
    );
  }
}
