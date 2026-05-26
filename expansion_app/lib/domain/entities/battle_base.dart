import 'package:equatable/equatable.dart';

import 'package:expansion/domain/enums/battle_side.dart';

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
  });

  final int id;
  final int x;
  final int y;
  final BattleSide side;
  final int ships;
  final double shield;
  final int maxShips;

  int get power => ships + shield.round();

  BattleBase copyWith({
    int? ships,
    double? shield,
    BattleSide? side,
  }) {
    return BattleBase(
      id: id,
      x: x,
      y: y,
      side: side ?? this.side,
      ships: ships ?? this.ships,
      shield: shield ?? this.shield,
      maxShips: maxShips,
    );
  }

  @override
  List<Object?> get props => [id, x, y, side, ships, shield, maxShips];
}
