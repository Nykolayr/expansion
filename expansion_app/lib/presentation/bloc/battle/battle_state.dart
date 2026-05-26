import 'package:equatable/equatable.dart';

import 'package:expansion/domain/entities/battle_snapshot.dart';
import 'package:expansion/game_core/battle/battle_engine.dart';

enum BattleStatus { initial, loading, playing, ended, failure }

class BattleState extends Equatable {
  const BattleState({
    this.status = BattleStatus.initial,
    this.sceneId = 1,
    this.snapshot,
    this.selectedBaseId,
    this.outcome,
    this.briefingRu = '',
    this.briefingEn = '',
    this.errorMessage,
  });

  final BattleStatus status;
  final int sceneId;
  final BattleSnapshot? snapshot;
  final int? selectedBaseId;
  final BattleOutcome? outcome;
  final String briefingRu;
  final String briefingEn;
  final String? errorMessage;

  bool get isPlaying => status == BattleStatus.playing;

  BattleState copyWith({
    BattleStatus? status,
    int? sceneId,
    BattleSnapshot? snapshot,
    int? selectedBaseId,
    bool clearSelection = false,
    BattleOutcome? outcome,
    String? briefingRu,
    String? briefingEn,
    String? errorMessage,
  }) {
    return BattleState(
      status: status ?? this.status,
      sceneId: sceneId ?? this.sceneId,
      snapshot: snapshot ?? this.snapshot,
      selectedBaseId:
          clearSelection ? null : selectedBaseId ?? this.selectedBaseId,
      outcome: outcome ?? this.outcome,
      briefingRu: briefingRu ?? this.briefingRu,
      briefingEn: briefingEn ?? this.briefingEn,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        sceneId,
        snapshot,
        selectedBaseId,
        outcome,
        briefingRu,
        briefingEn,
        errorMessage,
      ];
}
