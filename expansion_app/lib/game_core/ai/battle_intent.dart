import 'package:equatable/equatable.dart';

/// Намерение AI (применяет [BattleCubit] / движок).
sealed class BattleIntent extends Equatable {
  const BattleIntent();
}

class SendFleetIntent extends BattleIntent {
  const SendFleetIntent({required this.fromBaseId, required this.toBaseId});

  final int fromBaseId;
  final int toBaseId;

  @override
  List<Object?> get props => [fromBaseId, toBaseId];
}

class WaitIntent extends BattleIntent {
  const WaitIntent();

  @override
  List<Object?> get props => [];
}
