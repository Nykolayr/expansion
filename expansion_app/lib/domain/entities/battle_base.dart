import 'package:equatable/equatable.dart';

import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/domain/enums/neutral_base_kind.dart';
import 'package:expansion/domain/enums/tactical_upgrade_type.dart';

/// База на поле боя (состояние одной партии).
class BattleBase extends Equatable {
  const BattleBase({
    required this.id,
    required this.x,
    required this.y,
    required this.side,
    required this.ships,
    required this.shield,
    this.maxShips = 200,
    this.neutralKind,
    this.isCommandBase = false,
    this.resources = 0,
    this.speedBuild = 0.1,
    this.speedResources = 0.1,
    this.shieldUpgradeLevel = 0,
    this.buildUpgradeLevel = 0,
    this.maxShipsUpgradeLevel = 0,
    this.growthAccumulator = 0,
  });

  final int id;
  final int x;
  final int y;
  final BattleSide side;
  final int ships;
  final double shield;
  final int maxShips;
  final NeutralBaseKind? neutralKind;

  /// Главная «матка» (our/enemy.png); захваченные узлы — спрайты bases/.
  final bool isCommandBase;
  final double resources;
  final double speedBuild;
  final double speedResources;
  final int shieldUpgradeLevel;
  final int buildUpgradeLevel;
  final int maxShipsUpgradeLevel;
  final int growthAccumulator;

  static const int maxTacticalLevel = 5;

  int get power => ships + shield.round();

  int tacticalLevelFor(TacticalUpgradeType type) {
    switch (type) {
      case TacticalUpgradeType.shield:
        return shieldUpgradeLevel;
      case TacticalUpgradeType.buildSpeed:
        return buildUpgradeLevel;
      case TacticalUpgradeType.maxShips:
        return maxShipsUpgradeLevel;
    }
  }

  bool isTacticalMaxed(TacticalUpgradeType type) =>
      tacticalLevelFor(type) >= maxTacticalLevel;

  BattleBase copyWith({
    int? ships,
    double? shield,
    BattleSide? side,
    int? maxShips,
    NeutralBaseKind? neutralKind,
    bool? isCommandBase,
    double? resources,
    double? speedBuild,
    double? speedResources,
    int? shieldUpgradeLevel,
    int? buildUpgradeLevel,
    int? maxShipsUpgradeLevel,
    int? growthAccumulator,
  }) {
    return BattleBase(
      id: id,
      x: x,
      y: y,
      side: side ?? this.side,
      ships: ships ?? this.ships,
      shield: shield ?? this.shield,
      maxShips: maxShips ?? this.maxShips,
      neutralKind: neutralKind ?? this.neutralKind,
      isCommandBase: isCommandBase ?? this.isCommandBase,
      resources: resources ?? this.resources,
      speedBuild: speedBuild ?? this.speedBuild,
      speedResources: speedResources ?? this.speedResources,
      shieldUpgradeLevel: shieldUpgradeLevel ?? this.shieldUpgradeLevel,
      buildUpgradeLevel: buildUpgradeLevel ?? this.buildUpgradeLevel,
      maxShipsUpgradeLevel:
          maxShipsUpgradeLevel ?? this.maxShipsUpgradeLevel,
      growthAccumulator: growthAccumulator ?? this.growthAccumulator,
    );
  }

  @override
  List<Object?> get props => [
        id,
        x,
        y,
        side,
        ships,
        shield,
        maxShips,
        neutralKind,
        isCommandBase,
        resources,
        speedBuild,
        speedResources,
        shieldUpgradeLevel,
        buildUpgradeLevel,
        maxShipsUpgradeLevel,
        growthAccumulator,
      ];
}
