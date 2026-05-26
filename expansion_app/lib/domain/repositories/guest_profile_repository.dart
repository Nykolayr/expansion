import 'package:expansion/domain/entities/guest_profile.dart';
import 'package:expansion/domain/enums/game_difficulty.dart';

abstract class GuestProfileRepository {
  Future<GuestProfile> load();

  Future<void> save(GuestProfile profile);

  Future<void> setCurrentMission(int mapClassic);

  Future<void> markFirstBattleCompleted();

  Future<void> setDifficulty(GameDifficulty difficulty);
}
