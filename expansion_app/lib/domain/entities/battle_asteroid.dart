import 'package:equatable/equatable.dart';

/// Астероид, летящий через поле (MVP: урон базе при пересечении клетки).
class BattleAsteroid extends Equatable {
  const BattleAsteroid({
    required this.id,
    required this.fromX,
    required this.fromY,
    required this.toX,
    required this.toY,
    required this.power,
    this.visualIndex = 1,
    this.progress = 0,
  });

  final int id;
  final int fromX;
  final int fromY;
  final int toX;
  final int toY;
  final int power;
  final int visualIndex;
  final double progress;

  BattleAsteroid copyWith({double? progress, int? power}) {
    return BattleAsteroid(
      id: id,
      fromX: fromX,
      fromY: fromY,
      toX: toX,
      toY: toY,
      power: power ?? this.power,
      visualIndex: visualIndex,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props =>
      [id, fromX, fromY, toX, toY, power, visualIndex, progress];
}
