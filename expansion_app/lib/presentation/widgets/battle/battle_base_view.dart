import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:expansion/core/constants/battle_assets.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/presentation/widgets/battle/battle_entity_sprite.dart';

/// База в клетке: спрайт почти на всю ширину; HUD — отдельным слоем поверх флотов.
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

  static const double _sideMargin = 3;
  static const double _bottomStatBand = 0.20;

  static const TextStyle _shadow = TextStyle(
    shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
  );

  static const Color _statColor = ExpansionColors.accent;

  @override
  Widget build(BuildContext context) {
    final minSide = math.min(cellWidth, cellHeight);
    final spriteWidth = math.max(0, cellWidth - _sideMargin * 2);
    final statBand = cellHeight * _bottomStatBand;
    final spriteSize = math.min(spriteWidth, cellHeight - statBand).toDouble();

    return SizedBox(
      width: cellWidth,
      height: cellHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        fit: StackFit.expand,
        children: [
          Positioned(
            left: _sideMargin,
            right: _sideMargin,
            top: cellHeight * 0.04,
            bottom: statBand * 0.55,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: BattleEntitySprite(
                assetPath: BattleAssets.baseSprite(base),
                size: spriteSize,
              ),
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

/// Цифры кораблей, щита и ресурсов — поверх флотов и hazard'ов.
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
    final statFont = (minSide * 0.14).clamp(8.0, 11.0);

    final statLines = <Widget>[
      if (base.shield > 0)
        _HudLine(
          text: '⛨${base.shield.round()}',
          fontSize: statFont,
          color: BattleBaseView._statColor,
        ),
      if (base.side != BattleSide.neutral)
        _HudLine(
          text: '⚙${base.resources.round()}',
          fontSize: statFont,
          color: BattleBaseView._statColor,
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
            style: BattleBaseView._shadow.copyWith(
              color: hudColor,
              fontSize: shipFont,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ),
        if (statLines.isNotEmpty)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: statLines,
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
  });

  final String text;
  final double fontSize;
  final Color color;

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
        ),
      ),
    );
  }
}
