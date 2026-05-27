import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:expansion/core/constants/battle_assets.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/enums/battle_side.dart';

/// Летящий отряд — legacy SVG в рамке, поворот по направлению полёта.
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
    final frameColor = switch (side) {
      BattleSide.player => ExpansionColors.green,
      BattleSide.enemy => ExpansionColors.red,
      BattleSide.neutral => ExpansionColors.accent,
    };
    final tint = switch (side) {
      BattleSide.player => ExpansionColors.green,
      BattleSide.enemy => ExpansionColors.red,
      BattleSide.neutral => ExpansionColors.white,
    };

    return Transform.rotate(
      angle: angle,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(size * 0.12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: frameColor, width: 2),
          color: ExpansionColors.background.withValues(alpha: 0.55),
        ),
        child: SvgPicture.asset(
          BattleAssets.fleetSprite(side),
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(tint, BlendMode.srcIn),
        ),
      ),
    );
  }
}
