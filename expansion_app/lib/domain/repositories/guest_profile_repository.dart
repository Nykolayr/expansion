import 'package:expansion/domain/entities/guest_profile.dart';
import 'package:expansion/domain/enums/game_difficulty.dart';

abstract class GuestProfileRepository {
  Future<GuestProfile> load();

  Future<void> save(GuestProfile profile);

  Future<void> setCurrentMission(int mapClassic);

  Future<void> markFirstBattleCompleted();

  Future<void> setDifficulty(GameDifficulty difficulty);

  /// Учитывает поражение на миссии; возвращает новую длину серии на этой миссии.
  Future<int> recordMissionDefeat(int sceneId);

  Future<void> clearDefeatStreak();

  Future<void> markAsteroidTutorialSeen();

  Future<void> markDebrisTutorialSeen();

  Future<void> markMission1TutorialCompleted();

  Future<void> markMapTutorialSeen();

  Future<void> markFeatureIntroSeen(String storageKey);

  /// Эпилог кампании показан для [missionCount] миссий (актуально при OTA).
  Future<void> markCampaignEpilogueSeen(int missionCount);

  Future<void> ensureCampaignStartedAt();

  /// Дополнительные очки (rewarded после победы).
  Future<void> addBonusScore(int points);
}
