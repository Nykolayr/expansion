import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:expansion/core/constants/battle_assets.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/presentation/widgets/battle/battle_entity_sprite.dart';

/// База в клетке: крупный спрайт; HUD (корабли/щит) — отдельным слоем поверх флотов.
class BattleBaseView extends StatelessWidget {
  const BattleBaseView({
    required this.base,
    required this.cellWidth,
    required this.cellHeight,
    this.showUpgradeHint = false,
    this.showHud = true,
    super.key,
  });

  final BattleBase base;
  final double cellWidth;
  final double cellHeight;
  final bool showUpgradeHint;
  final bool showHud;

  static const TextStyle _shadow = TextStyle(
    shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
  );

  /// Щит и ресурсы — золотые, с контрастной подложкой (одинаково у игрока и врага).
  static const Color _statColor = ExpansionColors.accent;
  static const List<Shadow> _statShadows = [
    Shadow(color: Colors.black, offset: Offset(0, 1), blurRadius: 1),
    Shadow(color: Colors.black87, blurRadius: 6),
  ];

  @override
  Widget build(BuildContext context) {
    final minSide = math.min(cellWidth, cellHeight);
    final spriteSize =
        minSide * 0.88 * BattleAssets.baseSpriteScaleFactor(base);

    return SizedBox(
      width: cellWidth,
      height: cellHeight,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: BattleEntitySprite(
              assetPath: BattleAssets.baseSprite(base),
              size: spriteSize,
            ),
          ),
          if (showHud)
            BattleBaseHud(
              base: base,
              cellWidth: cellWidth,
              cellHeight: cellHeight,
            ),
          if (showUpgradeHint)
            Positioned(
              top: 2,
              right: 2,
              child: Text(
                '▲',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: (minSide * 0.30).clamp(20.0, 30.0),
                  fontWeight: FontWeight.w900,
                  height: 1,
                  shadows: const [
                    Shadow(color: Colors.black87, blurRadius: 2),
                    Shadow(color: Colors.black54, blurRadius: 6),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Цифры кораблей и щита — поверх флотов и hazard'ов.
class BattleBaseHud extends StatelessWidget {
  const BattleBaseHud({
    required this.base,
    required this.cellWidth,
    required this.cellHeight,
    super.key,
  });

  final BattleBase base;
  final double cellWidth;
  final double cellHeight;

  @override
  Widget build(BuildContext context) {
    final hudColor = switch (base.side) {
      BattleSide.player => Colors.cyanAccent,
      BattleSide.enemy => Colors.redAccent,
      BattleSide.neutral => Colors.white,
    };

    final minSide = math.min(cellWidth, cellHeight);
    final shipFont = (minSide * 0.22).clamp(11.0, 18.0);
    final statFont = (minSide * 0.16).clamp(9.0, 12.0);

    final statLines = <Widget>[
      if (base.shield > 0)
        _HudLine(
          text: '⛨${base.shield.round()}',
          fontSize: statFont,
          color: BattleBaseView._statColor,
          shadows: BattleBaseView._statShadows,
        ),
      if (base.side != BattleSide.neutral)
        _HudLine(
          text: '⚙${base.resources.round()}',
          fontSize: statFont,
          color: BattleBaseView._statColor,
          shadows: BattleBaseView._statShadows,
        ),
    ];

    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Text(
            '${base.ships}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: hudColor,
              fontSize: shipFont,
              fontWeight: FontWeight.w900,
              height: 1,
              shadows: const [
                Shadow(color: Colors.black, offset: Offset(0, 1), blurRadius: 2),
                Shadow(color: Colors.black87, blurRadius: 4),
              ],
            ),
          ),
        ),
        if (statLines.isNotEmpty)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.52),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: statLines,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _HudLine extends StatelessWidget {
  const _HudLine({
    required this.text,
    required this.fontSize,
    required this.color,
    required this.shadows,
  });

  final String text;
  final double fontSize;
  final Color color;
  final List<Shadow> shadows;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        maxLines: 1,
        style: BattleBaseView._shadow.copyWith(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          height: 1.05,
          shadows: shadows,
        ),
      ),
    );
  }
}
