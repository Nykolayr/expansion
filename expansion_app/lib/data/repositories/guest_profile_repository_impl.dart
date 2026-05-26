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
      displayName: _prefs.getString(PrefsKeys.guestDisplayName) ?? 'Гость',
      meta: PlayerMetaProgressCodec.decode(
        _prefs.getString(PrefsKeys.guestMetaProgress),
      ),
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
}
