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
    this.arcControlX,
    this.arcControlY,
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

  /// Контрольная точка квадратичной Безье (дуга). `null` — прямолинейный полёт.
  final double? arcControlX;
  final double? arcControlY;

  bool get usesArcPath => arcControlX != null && arcControlY != null;

  (double x, double y) gridPosition() {
    final t = progress.clamp(0.0, 1.0);
    if (!usesArcPath) {
      return (
        fromX + (toX - fromX) * t,
        fromY + (toY - fromY) * t,
      );
    }
    final cx = arcControlX!;
    final cy = arcControlY!;
    final omt = 1 - t;
    return (
      omt * omt * fromX + 2 * omt * t * cx + t * t * toX,
      omt * omt * fromY + 2 * omt * t * cy + t * t * toY,
    );
  }

  (double dx, double dy) gridTangent() {
    final t = progress.clamp(0.0, 1.0);
    if (!usesArcPath) {
      return (toX - fromX.toDouble(), toY - fromY.toDouble());
    }
    final cx = arcControlX!;
    final cy = arcControlY!;
    return (
      2 * (1 - t) * (cx - fromX) + 2 * t * (toX - cx),
      2 * (1 - t) * (cy - fromY) + 2 * t * (toY - cy),
    );
  }

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
      arcControlX: arcControlX,
      arcControlY: arcControlY,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fromX,
        fromY,
        toX,
        toY,
        power,
        kind,
        visualIndex,
        progress,
        arcControlX,
        arcControlY,
      ];
}
