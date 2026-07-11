import 'package:equatable/equatable.dart';

import 'package:expansion/domain/enums/battle_hazard_kind.dart';

/// Hazard, летящий через поле (астероид, обломки, …).
class BattleAsteroid extends Equatable {
  const BattleAsteroid({
    required this.id,
    required this.fromX,
    required this.fromY,
    required this.toX,
    required this.toY,
    required this.power,
    this.kind = BattleHazardKind.asteroid,
    this.visualIndex = 1,
    this.progress = 0,
  });

  final int id;
  final int fromX;
  final int fromY;
  final int toX;
  final int toY;
  final int power;
  final BattleHazardKind kind;
  final int visualIndex;
  final double progress;

  BattleAsteroid copyWith({
    double? progress,
    int? power,
    BattleHazardKind? kind,
  }) {
    return BattleAsteroid(
      id: id,
      fromX: fromX,
      fromY: fromY,
      toX: toX,
      toY: toY,
      power: power ?? this.power,
      kind: kind ?? this.kind,
      visualIndex: visualIndex,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props =>
      [id, fromX, fromY, toX, toY, power, kind, visualIndex, progress];
}
