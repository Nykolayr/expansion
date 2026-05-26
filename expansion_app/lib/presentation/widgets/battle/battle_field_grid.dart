import 'package:flutter/material.dart';

import 'package:expansion/core/constants/game_layout.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/entities/battle_snapshot.dart';
import 'package:expansion/domain/enums/battle_side.dart';

class BattleFieldGrid extends StatelessWidget {
  const BattleFieldGrid({
    required this.snapshot,
    required this.selectedBaseId,
    required this.onCellTap,
    super.key,
  });

  final BattleSnapshot snapshot;
  final int? selectedBaseId;
  final void Function(int x, int y) onCellTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: kBattleColumns / kBattleRows,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: kBattleColumns,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: kBattleColumns * kBattleRows,
        itemBuilder: (context, index) {
          final x = index % kBattleColumns + 1;
          final y = index ~/ kBattleColumns + 1;
          final base = snapshot.baseAt(x, y);
          final selected = base != null && base.id == selectedBaseId;

          return GestureDetector(
            onTap: () => onCellTap(x, y),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: ExpansionColors.background.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: selected
                      ? ExpansionColors.accent
                      : ExpansionColors.grey.withValues(alpha: 0.4),
                  width: selected ? 2 : 1,
                ),
              ),
              child: base == null
                  ? null
                  : Center(child: _BaseChip(base: base)),
            ),
          );
        },
      ),
    );
  }
}

class _BaseChip extends StatelessWidget {
  const _BaseChip({required this.base});

  final BattleBase base;

  @override
  Widget build(BuildContext context) {
    final color = switch (base.side) {
      BattleSide.player => Colors.cyanAccent,
      BattleSide.enemy => Colors.redAccent,
      BattleSide.neutral => Colors.amber,
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.hub, color: color, size: 22),
        Text(
          '${base.ships}',
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
