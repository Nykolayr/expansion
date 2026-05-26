import 'package:equatable/equatable.dart';

import 'package:expansion/domain/entities/player_meta_progress.dart';
import 'package:expansion/domain/enums/game_difficulty.dart';

class GuestProfile extends Equatable {
  GuestProfile({
    this.mapClassic = 1,
    this.scoreClassic = 0,
    this.difficulty = GameDifficulty.average,
    this.firstBattleCompleted = false,
    this.displayName = 'Гость',
    PlayerMetaProgress? meta,
  }) : meta = meta ?? PlayerMetaProgress.fresh();

  final int mapClassic;
  final int scoreClassic;
  final GameDifficulty difficulty;
  final bool firstBattleCompleted;
  final String displayName;
  final PlayerMetaProgress meta;

  GuestProfile copyWith({
    int? mapClassic,
    int? scoreClassic,
    GameDifficulty? difficulty,
    bool? firstBattleCompleted,
    String? displayName,
    PlayerMetaProgress? meta,
  }) {
    return GuestProfile(
      mapClassic: mapClassic ?? this.mapClassic,
      scoreClassic: scoreClassic ?? this.scoreClassic,
      difficulty: difficulty ?? this.difficulty,
      firstBattleCompleted:
          firstBattleCompleted ?? this.firstBattleCompleted,
      displayName: displayName ?? this.displayName,
      meta: meta ?? this.meta,
    );
  }

  @override
  List<Object?> get props => [
        mapClassic,
        scoreClassic,
        difficulty,
        firstBattleCompleted,
        displayName,
        meta,
      ];
}
