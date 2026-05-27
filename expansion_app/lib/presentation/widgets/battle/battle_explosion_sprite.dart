import 'package:flutter/material.dart';

import 'package:expansion/core/constants/battle_assets.dart';
import 'package:expansion/domain/entities/battle_explosion.dart';

/// Кадры взрыва legacy `explosion_01` … `explosion_09`.
class BattleExplosionSprite extends StatelessWidget {
  const BattleExplosionSprite({
    required this.explosion,
    required this.size,
    super.key,
  });

  final BattleExplosion explosion;
  final double size;

  @override
  Widget build(BuildContext context) {
    final frame = ((explosion.ageTicks / 2).floor() % 9) + 1;
    return Image.asset(
      BattleAssets.explosionFrame(frame),
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    );
  }
}
