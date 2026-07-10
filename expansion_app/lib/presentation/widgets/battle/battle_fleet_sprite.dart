import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:expansion/core/constants/battle_assets.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/enums/battle_side.dart';

/// Летящий отряд — SVG корабля, поворот по направлению (без рамки).
class BattleFleetSprite extends StatelessWidget {
  const BattleFleetSprite({
    required this.side,
    required this.size,
    required this.deltaX,
    required this.deltaY,
    super.key,
  });

  final BattleSide side;
  final double size;
  final double deltaX;
  final double deltaY;

  @override
  Widget build(BuildContext context) {
    final angle = math.atan2(deltaY, deltaX) + math.pi / 2;
    final tint = switch (side) {
      BattleSide.player => ExpansionColors.green,
      BattleSide.enemy => ExpansionColors.red,
      BattleSide.neutral => ExpansionColors.white,
    };

    return Transform.rotate(
      angle: angle,
      child: SvgPicture.asset(
        BattleAssets.fleetSprite(side),
        width: size,
        height: size,
        fit: BoxFit.contain,
        colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
      ),
    );
  }
}
