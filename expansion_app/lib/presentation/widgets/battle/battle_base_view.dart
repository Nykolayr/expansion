import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:expansion/core/constants/battle_assets.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/presentation/widgets/battle/battle_entity_sprite.dart';

/// База в клетке: крупный спрайт, корабли в центре, щит/ресурсы снизу.
class BattleBaseView extends StatelessWidget {
  const BattleBaseView({
    required this.base,
    required this.cellWidth,
    required this.cellHeight,
    this.showUpgradeHint = false,
    super.key,
  });

  final BattleBase base;
  final double cellWidth;
  final double cellHeight;
  final bool showUpgradeHint;

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

    final statColor = ExpansionColors.accent;

    final minSide = math.min(cellWidth, cellHeight);
    final spriteSize =
        minSide * 0.88 * BattleAssets.baseSpriteScaleFactor(base);
    final shipFont = (minSide * 0.22).clamp(11.0, 18.0);
    final statFont = (minSide * 0.14).clamp(8.0, 11.0);

    return SizedBox(
      width: cellWidth,
      height: cellHeight,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: BattleEntitySprite(
              assetPath: BattleAssets.baseSprite(base),
              size: spriteSize,
            ),
          ),
          if (base.side != BattleSide.neutral)
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: minSide * 0.08),
                child: Container(
                  width: minSide * 0.38,
                  height: minSide * 0.38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hudColor.withValues(alpha: 0.42),
                    border: Border.all(
                      color: hudColor.withValues(alpha: 0.9),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: minSide * 0.08),
              child: Text(
                '${base.ships}',
                style: _shadow.copyWith(
                  color: hudColor,
                  fontSize: shipFont,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (base.shield > 0)
                  _HudLine(
                    text: '⛨${base.shield.round()}',
                    fontSize: statFont,
                    color: statColor,
                  ),
                if (base.side != BattleSide.neutral)
                  _HudLine(
                    text: '⚙${base.resources.round()}',
                    fontSize: statFont,
                    color: statColor,
                  ),
              ],
            ),
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
