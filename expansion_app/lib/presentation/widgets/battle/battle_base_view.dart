import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:expansion/core/constants/battle_assets.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/presentation/widgets/battle/battle_entity_sprite.dart';

/// База в клетке: спрайт + HUD внутри [cellWidth]×[cellHeight] без overflow.
class BattleBaseView extends StatelessWidget {
  const BattleBaseView({
    required this.base,
    required this.cellWidth,
    required this.cellHeight,
    super.key,
  });

  final BattleBase base;
  final double cellWidth;
  final double cellHeight;

  static const TextStyle _shadow = TextStyle(
    shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
  );

  @override
  Widget build(BuildContext context) {
    final hudColor = switch (base.side) {
      BattleSide.player => Colors.cyanAccent,
      BattleSide.enemy => Colors.redAccent,
      BattleSide.neutral => Colors.white,
    };

    final minSide = math.min(cellWidth, cellHeight);
    final spriteSize =
        minSide * 0.5 * BattleAssets.baseSpriteScaleFactor(base);
    final hudFont = (minSide * 0.17).clamp(8.0, 11.0);

    final hudLines = <String>[
      '${base.ships}',
      if (base.shield > 0) '⛨${base.shield.round()}',
      if (base.side == BattleSide.player) '⚙${base.resources.round()}',
    ];

    return SizedBox(
      width: cellWidth,
      height: cellHeight,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        child: SizedBox(
          width: cellWidth,
          height: cellHeight,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            fit: StackFit.expand,
            children: [
              Align(
                alignment: const Alignment(0, -0.2),
                child: BattleEntitySprite(
                  assetPath: BattleAssets.baseSprite(base),
                  size: spriteSize,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < hudLines.length; i++)
                      _HudLine(
                        text: hudLines[i],
                        fontSize: hudFont - (i > 0 ? 1 : 0),
                        color: hudLines[i].startsWith('⚙')
                            ? ExpansionColors.accent
                            : hudColor,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
