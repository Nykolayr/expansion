import 'package:equatable/equatable.dart';

/// Взрыв при столкновении отрядов (кратковременный FX).
class BattleExplosion extends Equatable {
  const BattleExplosion({
    required this.id,
    required this.gridX,
    required this.gridY,
    required this.ageTicks,
  });

  final int id;
  final double gridX;
  final double gridY;
  final int ageTicks;

  static const int maxAgeTicks = 20;

  BattleExplosion copyWith({int? ageTicks}) {
    return BattleExplosion(
      id: id,
      gridX: gridX,
      gridY: gridY,
      ageTicks: ageTicks ?? this.ageTicks,
    );
  }

  @override
  List<Object?> get props => [id, gridX, gridY, ageTicks];
}
