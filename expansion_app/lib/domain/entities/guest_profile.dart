import 'package:equatable/equatable.dart';

import 'package:expansion/domain/entities/player_meta_progress.dart';
import 'package:expansion/domain/enums/game_difficulty.dart';
import 'package:expansion/domain/enums/univer_kind.dart';

class GuestProfile extends Equatable {
  GuestProfile({
    this.mapClassic = 1,
    this.scoreClassic = 0,
    this.difficulty = GameDifficulty.average,
    this.univerKind = UniverKind.classic,
    this.firstBattleCompleted = false,
    this.displayName = 'Гость',
    PlayerMetaProgress? meta,
  }) : meta = meta ?? PlayerMetaProgress.fresh();

  final int mapClassic;
  final int scoreClassic;
  final GameDifficulty difficulty;
  final UniverKind univerKind;
  final bool firstBattleCompleted;
  final String displayName;
  final PlayerMetaProgress meta;

  /// Есть что терять при «Новой игре» — показываем подтверждение сброса.
  bool get hasCampaignProgress =>
      firstBattleCompleted ||
      mapClassic > 1 ||
      scoreClassic > 0 ||
      meta.enemyPowerLevel > 0 ||
      meta.slots.any((slot) => slot.level > 0);

  GuestProfile copyWith({
    int? mapClassic,
    int? scoreClassic,
    GameDifficulty? difficulty,
    UniverKind? univerKind,
    bool? firstBattleCompleted,
    String? displayName,
    PlayerMetaProgress? meta,
  }) {
    return GuestProfile(
      mapClassic: mapClassic ?? this.mapClassic,
      scoreClassic: scoreClassic ?? this.scoreClassic,
      difficulty: difficulty ?? this.difficulty,
      univerKind: univerKind ?? this.univerKind,
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
        univerKind,
        firstBattleCompleted,
        displayName,
        meta,
      ];
}
