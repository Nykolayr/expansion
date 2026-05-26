import 'package:equatable/equatable.dart';

import 'package:expansion/domain/enums/battle_side.dart';

/// Отряд в полёте между базами.
class BattleFleet extends Equatable {
  const BattleFleet({
    required this.id,
    required this.fromBaseId,
    required this.toBaseId,
    required this.ships,
    required this.side,
    required this.progress,
  });

  final int id;
  final int fromBaseId;
  final int toBaseId;
  final int ships;
  final BattleSide side;

  /// 0…1 — доля пути до цели.
  final double progress;

  BattleFleet copyWith({double? progress}) {
    return BattleFleet(
      id: id,
      fromBaseId: fromBaseId,
      toBaseId: toBaseId,
      ships: ships,
      side: side,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [id, fromBaseId, toBaseId, ships, side, progress];
}
