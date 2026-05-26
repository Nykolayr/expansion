import 'package:flutter/material.dart';

import 'package:expansion/core/constants/game_layout.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/entities/battle_fleet.dart';
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

  static const double _spacing = 4;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: kBattleColumns / kBattleRows,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellW =
              (constraints.maxWidth - _spacing * (kBattleColumns - 1)) /
                  kBattleColumns;
          final cellH =
              (constraints.maxHeight - _spacing * (kBattleRows - 1)) /
                  kBattleRows;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: kBattleColumns,
                  crossAxisSpacing: _spacing,
                  mainAxisSpacing: _spacing,
                  mainAxisExtent: cellH,
                ),
                itemCount: kBattleColumns * kBattleRows,
                itemBuilder: (context, index) {
                  final x = index % kBattleColumns + 1;
                  final y = index ~/ kBattleColumns + 1;
                  final base = snapshot.baseAt(x, y);
                  final selected =
                      base != null && base.id == selectedBaseId;

                  return GestureDetector(
                    onTap: () => onCellTap(x, y),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: ExpansionColors.background
                            .withValues(alpha: 0.35),
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
              ...snapshot.fleets.map(
                (fleet) => _FleetMarker(
                  fleet: fleet,
                  snapshot: snapshot,
                  cellW: cellW,
                  cellH: cellH,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FleetMarker extends StatelessWidget {
  const _FleetMarker({
    required this.fleet,
    required this.snapshot,
    required this.cellW,
    required this.cellH,
  });

  final BattleFleet fleet;
  final BattleSnapshot snapshot;
  final double cellW;
  final double cellH;

  @override
  Widget build(BuildContext context) {
    final from = snapshot.baseById(fleet.fromBaseId);
    final to = snapshot.baseById(fleet.toBaseId);
    if (from == null || to == null) return const SizedBox.shrink();

    final t = fleet.progress.clamp(0.0, 1.0);
    final fromX = _cellLeft(from.x) + cellW / 2;
    final fromY = _cellTop(from.y) + cellH / 2;
    final toX = _cellLeft(to.x) + cellW / 2;
    final toY = _cellTop(to.y) + cellH / 2;

    final left = fromX + (toX - fromX) * t - 10;
    final top = fromY + (toY - fromY) * t - 10;

    final color = switch (fleet.side) {
      BattleSide.player => Colors.cyanAccent,
      BattleSide.enemy => Colors.redAccent,
      BattleSide.neutral => Colors.amber,
    };

    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.5),
              blurRadius: 6,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          '${fleet.ships}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  double _cellLeft(int x) => (x - 1) * (cellW + BattleFieldGrid._spacing);

  double _cellTop(int y) => (y - 1) * (cellH + BattleFieldGrid._spacing);
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
        if (base.shield > 0)
          Text(
            '⛨${base.shield.round()}',
            style: TextStyle(color: color.withValues(alpha: 0.85), fontSize: 9),
          ),
      ],
    );
  }
}
