import 'package:flutter/material.dart';

import 'package:expansion/core/constants/battle_assets.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/presentation/widgets/battle/battle_entity_sprite.dart';

/// База на клетке: спрайт + HUD (корабли, щит, ресурсы).
class BattleBaseView extends StatelessWidget {
  const BattleBaseView({
    required this.base,
    required this.spriteSize,
    super.key,
  });

  final BattleBase base;
  final double spriteSize;

  @override
  Widget build(BuildContext context) {
    final hudColor = switch (base.side) {
      BattleSide.player => Colors.cyanAccent,
      BattleSide.enemy => Colors.redAccent,
      BattleSide.neutral => Colors.amber,
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BattleEntitySprite(
          assetPath: BattleAssets.baseSprite(base),
          size: spriteSize,
          fallback: Icon(Icons.hub, color: hudColor, size: spriteSize * 0.85),
        ),
        Text(
          '${base.ships}',
          style: TextStyle(
            color: hudColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(color: Colors.black87, blurRadius: 4),
            ],
          ),
        ),
        if (base.shield > 0)
          Text(
            '⛨${base.shield.round()}',
            style: TextStyle(
              color: hudColor.withValues(alpha: 0.9),
              fontSize: 9,
              shadows: const [
                Shadow(color: Colors.black87, blurRadius: 3),
              ],
            ),
          ),
        if (base.side == BattleSide.player)
          Text(
            '⚙${base.resources.round()}',
            style: const TextStyle(
              color: ExpansionColors.accent,
              fontSize: 8,
              shadows: [
                Shadow(color: Colors.black87, blurRadius: 3),
              ],
            ),
          ),
      ],
    );
  }
}
