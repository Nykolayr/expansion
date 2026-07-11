import 'package:shared_preferences/shared_preferences.dart';

import 'package:expansion/core/constants/prefs_keys.dart';
import 'package:expansion/data/models/player_meta_progress_codec.dart';
import 'package:expansion/domain/entities/guest_profile.dart';
import 'package:expansion/domain/enums/game_difficulty.dart';
import 'package:expansion/domain/enums/univer_kind.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';

class GuestProfileRepositoryImpl implements GuestProfileRepository {
  GuestProfileRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<GuestProfile> load() async {
    return GuestProfile(
      mapClassic: _prefs.getInt(PrefsKeys.guestMapClassic) ?? 1,
      scoreClassic: _prefs.getInt(PrefsKeys.guestScoreClassic) ?? 0,
      difficulty: GameDifficulty.fromStorage(
        _prefs.getString(PrefsKeys.guestDifficulty),
      ),
      univerKind: UniverKind.fromStorage(
        _prefs.getString(PrefsKeys.guestUniverKind),
      ),
      firstBattleCompleted:
          _prefs.getBool(PrefsKeys.guestFirstBattleCompleted) ?? false,
      displayName: _prefs.getString(PrefsKeys.guestDisplayName) ?? '',
      meta: PlayerMetaProgressCodec.decode(
        _prefs.getString(PrefsKeys.guestMetaProgress),
      ),
      defeatStreakSceneId:
          _prefs.getInt(PrefsKeys.guestDefeatStreakSceneId) ?? 0,
      defeatStreakCount: _prefs.getInt(PrefsKeys.guestDefeatStreakCount) ?? 0,
      asteroidTutorialSeen:
          _prefs.getBool(PrefsKeys.guestAsteroidTutorialSeen) ?? false,
      mission1TutorialCompleted:
          _prefs.getBool(PrefsKeys.guestMission1TutorialCompleted) ?? false,
      mapTutorialSeen: _prefs.getBool(PrefsKeys.guestMapTutorialSeen) ?? false,
      seenFeatureIntros: _decodeFeatureIntros(
        _prefs.getString(PrefsKeys.guestSeenFeatureIntros),
      ),
      campaignStartedAtMillis:
          _prefs.getInt(PrefsKeys.guestCampaignStartedAt) ?? 0,
    );
  }

  @override
  Future<void> save(GuestProfile profile) async {
    await _prefs.setInt(PrefsKeys.guestMapClassic, profile.mapClassic);
    await _prefs.setInt(PrefsKeys.guestScoreClassic, profile.scoreClassic);
    await _prefs.setString(
      PrefsKeys.guestDifficulty,
      profile.difficulty.name,
    );
    await _prefs.setString(
      PrefsKeys.guestUniverKind,
      profile.univerKind.name,
    );
    await _prefs.setBool(
      PrefsKeys.guestFirstBattleCompleted,
      profile.firstBattleCompleted,
    );
    await _prefs.setString(PrefsKeys.guestDisplayName, profile.displayName);
    await _prefs.setString(
      PrefsKeys.guestMetaProgress,
      PlayerMetaProgressCodec.encode(profile.meta),
    );
    await _prefs.setInt(
      PrefsKeys.guestDefeatStreakSceneId,
      profile.defeatStreakSceneId,
    );
    await _prefs.setInt(
      PrefsKeys.guestDefeatStreakCount,
      profile.defeatStreakCount,
    );
    await _prefs.setBool(
      PrefsKeys.guestAsteroidTutorialSeen,
      profile.asteroidTutorialSeen,
    );
    await _prefs.setBool(
      PrefsKeys.guestMission1TutorialCompleted,
      profile.mission1TutorialCompleted,
    );
    await _prefs.setBool(
      PrefsKeys.guestMapTutorialSeen,
      profile.mapTutorialSeen,
    );
    await _prefs.setString(
      PrefsKeys.guestSeenFeatureIntros,
      profile.seenFeatureIntros.join(','),
    );
    await _prefs.setInt(
      PrefsKeys.guestCampaignStartedAt,
      profile.campaignStartedAtMillis,
    );
  }

  @override
  Future<void> setCurrentMission(int mapClassic) async {
    final current = await load();
    await save(current.copyWith(mapClassic: mapClassic));
  }

  @override
  Future<void> markFirstBattleCompleted() async {
    final current = await load();
    await save(current.copyWith(firstBattleCompleted: true));
  }

  @override
  Future<void> setDifficulty(GameDifficulty difficulty) async {
    final current = await load();
    await save(current.copyWith(difficulty: difficulty));
  }

  @override
  Future<int> recordMissionDefeat(int sceneId) async {
    final current = await load();
    final count = current.defeatStreakSceneId == sceneId
        ? current.defeatStreakCount + 1
        : 1;
    await save(
      current.copyWith(
        defeatStreakSceneId: sceneId,
        defeatStreakCount: count,
      ),
    );
    return count;
  }

  @override
  Future<void> clearDefeatStreak() async {
    final current = await load();
    if (current.defeatStreakCount == 0 && current.defeatStreakSceneId == 0) {
      return;
    }
    await save(
      current.copyWith(
        defeatStreakSceneId: 0,
        defeatStreakCount: 0,
      ),
    );
  }

  @override
  Future<void> markAsteroidTutorialSeen() async {
    final current = await load();
    if (current.asteroidTutorialSeen) return;
    await save(current.copyWith(asteroidTutorialSeen: true));
  }

  @override
  Future<void> markMission1TutorialCompleted() async {
    final current = await load();
    if (current.mission1TutorialCompleted) return;
    await save(current.copyWith(mission1TutorialCompleted: true));
  }

  @override
  Future<void> markMapTutorialSeen() async {
    final current = await load();
    if (current.mapTutorialSeen) return;
    await save(current.copyWith(mapTutorialSeen: true));
  }

  @override
  Future<void> markFeatureIntroSeen(String storageKey) async {
    final current = await load();
    if (current.hasSeenFeatureIntro(storageKey)) return;
    await save(
      current.copyWith(
        seenFeatureIntros: {...current.seenFeatureIntros, storageKey},
      ),
    );
  }

  @override
  Future<void> ensureCampaignStartedAt() async {
    final current = await load();
    if (current.campaignStartedAtMillis > 0) return;
    await save(
      current.copyWith(
        campaignStartedAtMillis: DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  static Set<String> _decodeFeatureIntros(String? raw) {
    if (raw == null || raw.trim().isEmpty) return {};
    return raw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toSet();
  }
}
