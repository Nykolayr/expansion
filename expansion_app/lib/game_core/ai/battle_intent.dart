import 'package:equatable/equatable.dart';

/// Намерение AI (применяет [BattleCubit] / движок).
sealed class BattleIntent extends Equatable {
  const BattleIntent();
}

class SendFleetIntent extends BattleIntent {
  const SendFleetIntent({
    required this.fromBaseId,
    required this.toBaseId,
    this.shipCount,
  });

  final int fromBaseId;
  final int toBaseId;

  /// Если null — отправляются все корабли (игрок).
  final int? shipCount;

  @override
  List<Object?> get props => [fromBaseId, toBaseId, shipCount];
}

class WaitIntent extends BattleIntent {
  const WaitIntent();

  @override
  List<Object?> get props => [];
}
