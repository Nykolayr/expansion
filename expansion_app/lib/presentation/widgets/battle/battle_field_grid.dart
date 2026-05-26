import 'package:flutter/material.dart';

import 'package:expansion/core/constants/battle_assets.dart';
import 'package:expansion/core/constants/game_layout.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/entities/battle_asteroid.dart';
import 'package:expansion/domain/entities/battle_fleet.dart';
import 'package:expansion/domain/entities/battle_snapshot.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/presentation/widgets/battle/battle_base_view.dart';
import 'package:expansion/presentation/widgets/battle/battle_entity_sprite.dart';

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
          final spriteSize = (cellW < cellH ? cellW : cellH) * 0.72;

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
                          : Center(
                              child: BattleBaseView(
                                base: base,
                                spriteSize: spriteSize,
                              ),
                            ),
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
              ...snapshot.asteroids.map(
                (asteroid) => _AsteroidMarker(
                  asteroid: asteroid,
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

  static const double _markerSize = 28;

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

    final left = fromX + (toX - fromX) * t - _markerSize / 2;
    final top = fromY + (toY - fromY) * t - _markerSize / 2;

    final hudColor = switch (fleet.side) {
      BattleSide.player => Colors.cyanAccent,
      BattleSide.enemy => Colors.redAccent,
      BattleSide.neutral => Colors.amber,
    };

    return Positioned(
      left: left,
      top: top,
      child: SizedBox(
        width: _markerSize,
        height: _markerSize,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            BattleEntitySprite(
              assetPath: BattleAssets.fleetSprite(fleet.side),
              size: _markerSize,
              fallback: Container(
                decoration: BoxDecoration(
                  color: hudColor.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Text(
              '${fleet.ships}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black, blurRadius: 3)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _cellLeft(int x) => (x - 1) * (cellW + BattleFieldGrid._spacing);

  double _cellTop(int y) => (y - 1) * (cellH + BattleFieldGrid._spacing);
}

class _AsteroidMarker extends StatelessWidget {
  const _AsteroidMarker({
    required this.asteroid,
    required this.cellW,
    required this.cellH,
  });

  final BattleAsteroid asteroid;
  final double cellW;
  final double cellH;

  static const double _markerSize = 30;

  @override
  Widget build(BuildContext context) {
    final t = asteroid.progress.clamp(0.0, 1.0);
    final cx = asteroid.fromX + (asteroid.toX - asteroid.fromX) * t;
    final cy = asteroid.fromY + (asteroid.toY - asteroid.fromY) * t;
    final left =
        (cx - 1) * (cellW + BattleFieldGrid._spacing) + cellW / 2 - _markerSize / 2;
    final top =
        (cy - 1) * (cellH + BattleFieldGrid._spacing) + cellH / 2 - _markerSize / 2;

    return Positioned(
      left: left,
      top: top,
      child: SizedBox(
        width: _markerSize,
        height: _markerSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            BattleEntitySprite(
              assetPath: BattleAssets.asteroid(asteroid.visualIndex),
              size: _markerSize,
              fallback: Icon(
                Icons.brightness_7,
                color: Colors.orange.shade700,
                size: _markerSize * 0.9,
              ),
            ),
            Text(
              '${asteroid.power}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black, blurRadius: 3)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
