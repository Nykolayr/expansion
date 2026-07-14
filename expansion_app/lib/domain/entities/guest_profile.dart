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
    this.displayName = '',
    this.defeatStreakSceneId = 0,
    this.defeatStreakCount = 0,
    this.asteroidTutorialSeen = false,
    this.debrisTutorialSeen = false,
    this.mission1TutorialCompleted = false,
    this.mapTutorialSeen = false,
    Set<String>? seenFeatureIntros,
    this.campaignStartedAtMillis = 0,
    this.campaignEpilogueSeenForCount = 0,
    this.adsRemoved = false,
    this.supporterTier = 0,
    PlayerMetaProgress? meta,
  })  : seenFeatureIntros = seenFeatureIntros ?? const {},
        meta = meta ?? PlayerMetaProgress.fresh();

  final int mapClassic;
  final int scoreClassic;
  final GameDifficulty difficulty;
  final UniverKind univerKind;
  final bool firstBattleCompleted;
  final String displayName;

  /// Миссия, на которой копится серия поражений (0 — нет серии).
  final int defeatStreakSceneId;

  /// Подряд поражений на [defeatStreakSceneId].
  final int defeatStreakCount;

  /// Показана подсказка при первом астероиде.
  final bool asteroidTutorialSeen;

  /// Показана подсказка при первых обломках (м5).
  final bool debrisTutorialSeen;

  /// Пройден пошаговый туториал миссии 1.
  final bool mission1TutorialCompleted;

  /// Показана подсказка на карте кампании.
  final bool mapTutorialSeen;

  /// Один раз показанные интро новых механик (mediumBase, largeBase, …).
  final Set<String> seenFeatureIntros;

  /// Unix-ms старта кампании (0 — не задано).
  final int campaignStartedAtMillis;

  /// Для скольких миссий кампании уже показан эпилог (0 — ни разу).
  final int campaignEpilogueSeenForCount;

  /// Куплено «убрать рекламу» (IAP).
  final bool adsRemoved;

  /// Уровень поддержки 0–3 (косметика, без P2W).
  final int supporterTier;
  final PlayerMetaProgress meta;

  /// Есть что терять при «Новой игре» — показываем подтверждение сброса.
  bool get hasCampaignProgress =>
      firstBattleCompleted ||
      mapClassic > 1 ||
      scoreClassic > 0 ||
      meta.enemyPowerLevel > 0 ||
      meta.slots.any((slot) => slot.level > 0);

  bool hasSeenFeatureIntro(String storageKey) =>
      seenFeatureIntros.contains(storageKey);

  GuestProfile copyWith({
    int? mapClassic,
    int? scoreClassic,
    GameDifficulty? difficulty,
    UniverKind? univerKind,
    bool? firstBattleCompleted,
    String? displayName,
    int? defeatStreakSceneId,
    int? defeatStreakCount,
    bool? asteroidTutorialSeen,
    bool? debrisTutorialSeen,
    bool? mission1TutorialCompleted,
    bool? mapTutorialSeen,
    Set<String>? seenFeatureIntros,
    int? campaignStartedAtMillis,
    int? campaignEpilogueSeenForCount,
    bool? adsRemoved,
    int? supporterTier,
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
      defeatStreakSceneId: defeatStreakSceneId ?? this.defeatStreakSceneId,
      defeatStreakCount: defeatStreakCount ?? this.defeatStreakCount,
      asteroidTutorialSeen: asteroidTutorialSeen ?? this.asteroidTutorialSeen,
      debrisTutorialSeen: debrisTutorialSeen ?? this.debrisTutorialSeen,
      mission1TutorialCompleted:
          mission1TutorialCompleted ?? this.mission1TutorialCompleted,
      mapTutorialSeen: mapTutorialSeen ?? this.mapTutorialSeen,
      seenFeatureIntros: seenFeatureIntros ?? this.seenFeatureIntros,
      campaignStartedAtMillis:
          campaignStartedAtMillis ?? this.campaignStartedAtMillis,
      campaignEpilogueSeenForCount: campaignEpilogueSeenForCount ??
          this.campaignEpilogueSeenForCount,
      adsRemoved: adsRemoved ?? this.adsRemoved,
      supporterTier: supporterTier ?? this.supporterTier,
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
        defeatStreakSceneId,
        defeatStreakCount,
        asteroidTutorialSeen,
        debrisTutorialSeen,
        mission1TutorialCompleted,
        mapTutorialSeen,
        seenFeatureIntros,
        campaignStartedAtMillis,
        campaignEpilogueSeenForCount,
        adsRemoved,
        supporterTier,
        meta,
      ];
}
