import 'package:flutter/material.dart';

import 'package:expansion/core/constants/battle_assets.dart';
import 'package:expansion/core/constants/game_layout.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/entities/battle_asteroid.dart';
import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/entities/battle_explosion.dart';
import 'package:expansion/domain/entities/battle_fleet.dart';
import 'package:expansion/domain/entities/battle_snapshot.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/presentation/widgets/battle/battle_base_view.dart';
import 'package:expansion/presentation/widgets/battle/battle_drag_line_painter.dart';
import 'package:expansion/presentation/widgets/battle/battle_entity_sprite.dart';
import 'package:expansion/presentation/widgets/battle/battle_explosion_sprite.dart';
import 'package:expansion/presentation/widgets/battle/battle_fleet_sprite.dart';

/// Поле 5×8: свайп со своей базы на цель; тап по своей базе — панель улучшений.
class BattleFieldGrid extends StatefulWidget {
  const BattleFieldGrid({
    required this.snapshot,
    required this.selectedBaseId,
    required this.upgradableBaseIds,
    required this.onPlayerBaseTap,
    required this.onFleetDrag,
    this.onDismissOverlay,
    this.blockedCellX,
    this.blockedCellY,
    this.onDragStarted,
    super.key,
  });

  final BattleSnapshot snapshot;
  final int? selectedBaseId;
  final Set<int> upgradableBaseIds;
  final void Function(int baseId) onPlayerBaseTap;

  /// `from` и `to` — координаты клеток 1-based. Возвращает успех отправки.
  final bool Function(int fromX, int fromY, int toX, int toY) onFleetDrag;

  /// Тап вне своей базы — закрыть панель улучшений.
  final VoidCallback? onDismissOverlay;
  final int? blockedCellX;
  final int? blockedCellY;
  final VoidCallback? onDragStarted;

  static const double _spacing = 4;

  @override
  State<BattleFieldGrid> createState() => _BattleFieldGridState();
}

class _BattleFieldGridState extends State<BattleFieldGrid> {
  int? _dragFromX;
  int? _dragFromY;
  Offset? _dragStartLocal;
  Offset? _dragCurrentLocal;
  bool _panMoved = false;

  static const double _tapSlop = 12;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
        final gridW = constraints.maxWidth;
        final gridH = constraints.maxHeight;
        final cellW = (gridW - BattleFieldGrid._spacing * (kBattleColumns - 1)) /
            kBattleColumns;
        final cellH = (gridH - BattleFieldGrid._spacing * (kBattleRows - 1)) /
            kBattleRows;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (d) => _onPanStart(d.localPosition, gridW, gridH),
          onPanUpdate: (d) => _onPanUpdate(d.localPosition),
          onPanEnd: (d) => _onPanEnd(d.localPosition, gridW, gridH),
          onTapUp: (d) => _onTapUp(d.localPosition, gridW, gridH),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  for (var y = 1; y <= kBattleRows; y++)
                    Expanded(
                      child: Row(
                        children: [
                          for (var x = 1; x <= kBattleColumns; x++)
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: x > 1 ? BattleFieldGrid._spacing / 2 : 0,
                                  right: x < kBattleColumns
                                      ? BattleFieldGrid._spacing / 2
                                      : 0,
                                  top: y > 1 ? BattleFieldGrid._spacing / 2 : 0,
                                  bottom: y < kBattleRows
                                      ? BattleFieldGrid._spacing / 2
                                      : 0,
                                ),
                                child: _buildCell(
                                  x: x,
                                  y: y,
                                  base: widget.snapshot.baseAt(x, y),
                                  cellW: cellW,
                                  cellH: cellH,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
              ...widget.snapshot.fleets.map(
                (fleet) => _FleetMarker(
                  fleet: fleet,
                  snapshot: widget.snapshot,
                  cellW: cellW,
                  cellH: cellH,
                  spacing: BattleFieldGrid._spacing,
                ),
              ),
              ...widget.snapshot.asteroids.map(
                (asteroid) => _AsteroidMarker(
                  asteroid: asteroid,
                  cellW: cellW,
                  cellH: cellH,
                  spacing: BattleFieldGrid._spacing,
                ),
              ),
              ...widget.snapshot.explosions.map(
                (explosion) => _ExplosionMarker(
                  explosion: explosion,
                  cellW: cellW,
                  cellH: cellH,
                  spacing: BattleFieldGrid._spacing,
                ),
              ),
              if (_dragFromX != null &&
                  _dragStartLocal != null &&
                  _dragCurrentLocal != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: BattleDragLinePainter(
                        from: _cellCenter(
                          _dragFromX!,
                          _dragFromY!,
                          cellW,
                          cellH,
                        ),
                        to: _dragCurrentLocal!,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
      ),
    );
  }

  Widget _buildCell({
    required int x,
    required int y,
    required BattleBase? base,
    required double cellW,
    required double cellH,
  }) {
    final selected = base != null && base.id == widget.selectedBaseId;
    final blocked = widget.blockedCellX == x && widget.blockedCellY == y;
    const pad = 2.0;
    final innerW = cellW - pad * 2;
    final innerH = cellH - pad * 2;

    return Stack(
      fit: base == null ? StackFit.passthrough : StackFit.expand,
      children: [
        if (selected || blocked)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: blocked
                      ? ExpansionColors.red
                      : ExpansionColors.accent,
                  width: 2,
                ),
              ),
            ),
          ),
        if (base != null)
          Padding(
            padding: const EdgeInsets.all(pad),
            child: BattleBaseView(
              base: base,
              cellWidth: innerW,
              cellHeight: innerH,
              showUpgradeHint: widget.upgradableBaseIds.contains(base.id),
            ),
          ),
          if (blocked)
            Positioned.fill(
              child: Center(
                child: Icon(
                  Icons.close,
                  color: ExpansionColors.red,
                  size: (cellW * 0.55).clamp(28.0, 48.0),
                  shadows: const [
                    Shadow(color: Colors.black, blurRadius: 6),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  void _onPanStart(Offset local, double gridW, double gridH) {
    final cell = _cellAt(local, gridW, gridH);
    if (cell == null) return;
    final base = widget.snapshot.baseAt(cell.$1, cell.$2);
    if (base == null || base.side != BattleSide.player) return;

    widget.onDragStarted?.call();

    setState(() {
      _dragFromX = cell.$1;
      _dragFromY = cell.$2;
      _dragStartLocal = local;
      _dragCurrentLocal = local;
      _panMoved = false;
    });
  }

  void _onPanUpdate(Offset local) {
    if (_dragFromX == null) return;
    if (_dragStartLocal != null &&
        (local - _dragStartLocal!).distance > _tapSlop) {
      _panMoved = true;
    }
    setState(() => _dragCurrentLocal = local);
  }

  void _onPanEnd(Offset local, double gridW, double gridH) {
    if (_dragFromX == null || !_panMoved) {
      _clearDrag();
      return;
    }

    final fromX = _dragFromX!;
    final fromY = _dragFromY!;
    final target = _cellAt(local, gridW, gridH);
    _clearDrag();

    if (target == null) return;
    widget.onFleetDrag(fromX, fromY, target.$1, target.$2);
  }

  void _onTapUp(Offset local, double gridW, double gridH) {
    if (_panMoved) {
      _panMoved = false;
      return;
    }

    final cell = _cellAt(local, gridW, gridH);
    if (cell == null) {
      widget.onDismissOverlay?.call();
      return;
    }
    final base = widget.snapshot.baseAt(cell.$1, cell.$2);
    if (base != null && base.side == BattleSide.player) {
      widget.onPlayerBaseTap(base.id);
      return;
    }
    widget.onDismissOverlay?.call();
  }

  void _clearDrag() {
    if (!mounted) return;
    setState(() {
      _dragFromX = null;
      _dragFromY = null;
      _dragStartLocal = null;
      _dragCurrentLocal = null;
    });
  }

  (int x, int y)? _cellAt(Offset local, double gridW, double gridH) {
    final cellW = (gridW - BattleFieldGrid._spacing * (kBattleColumns - 1)) /
        kBattleColumns;
    final cellH = (gridH - BattleFieldGrid._spacing * (kBattleRows - 1)) /
        kBattleRows;

    var xAcc = 0.0;
    for (var x = 1; x <= kBattleColumns; x++) {
      if (local.dx < xAcc + cellW) {
        var yAcc = 0.0;
        for (var y = 1; y <= kBattleRows; y++) {
          if (local.dy < yAcc + cellH) {
            return (x, y);
          }
          yAcc += cellH + BattleFieldGrid._spacing;
        }
        return null;
      }
      xAcc += cellW + BattleFieldGrid._spacing;
    }
    return null;
  }

  Offset _cellCenter(int x, int y, double cellW, double cellH) {
    final left = (x - 1) * (cellW + BattleFieldGrid._spacing);
    final top = (y - 1) * (cellH + BattleFieldGrid._spacing);
    return Offset(left + cellW / 2, top + cellH / 2);
  }
}

class _FleetMarker extends StatelessWidget {
  const _FleetMarker({
    required this.fleet,
    required this.snapshot,
    required this.cellW,
    required this.cellH,
    required this.spacing,
  });

  final BattleFleet fleet;
  final BattleSnapshot snapshot;
  final double cellW;
  final double cellH;
  final double spacing;

  static const double _markerSize = 36;

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
            BattleFleetSprite(
              side: fleet.side,
              size: _markerSize * 0.85,
              deltaX: toX - fromX,
              deltaY: toY - fromY,
            ),
            Text(
              '${fleet.ships}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _cellLeft(int x) => (x - 1) * (cellW + spacing);

  double _cellTop(int y) => (y - 1) * (cellH + spacing);
}

class _AsteroidMarker extends StatelessWidget {
  const _AsteroidMarker({
    required this.asteroid,
    required this.cellW,
    required this.cellH,
    required this.spacing,
  });

  final BattleAsteroid asteroid;
  final double cellW;
  final double cellH;
  final double spacing;

  static const double _markerSize = 30;

  @override
  Widget build(BuildContext context) {
    final t = asteroid.progress.clamp(0.0, 1.0);
    final cx = asteroid.fromX + (asteroid.toX - asteroid.fromX) * t;
    final cy = asteroid.fromY + (asteroid.toY - asteroid.fromY) * t;
    final left = (cx - 1) * (cellW + spacing) + cellW / 2 - _markerSize / 2;
    final top = (cy - 1) * (cellH + spacing) + cellH / 2 - _markerSize / 2;

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

class _ExplosionMarker extends StatelessWidget {
  const _ExplosionMarker({
    required this.explosion,
    required this.cellW,
    required this.cellH,
    required this.spacing,
  });

  final BattleExplosion explosion;
  final double cellW;
  final double cellH;
  final double spacing;

  static const double _size = 52;

  @override
  Widget build(BuildContext context) {
    final left = (explosion.gridX - 1) * (cellW + spacing) +
        cellW / 2 -
        _size / 2;
    final top = (explosion.gridY - 1) * (cellH + spacing) +
        cellH / 2 -
        _size / 2;

    return Positioned(
      left: left,
      top: top,
      child: IgnorePointer(
        child: BattleExplosionSprite(
          explosion: explosion,
          size: _size,
        ),
      ),
    );
  }
}
