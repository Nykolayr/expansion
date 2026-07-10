import 'package:expansion/domain/entities/meta_battle_bonuses.dart';
import 'package:expansion/domain/enums/game_difficulty.dart';
import 'package:expansion/game_core/battle/battle_engine.dart';

/// Создание сессии боя из контента кампании (реализация в data).
abstract class BattleSessionFactory {
  Future<BattleEngine?> createEngine(
    int sceneId, {
    MetaBattleBonuses bonuses = MetaBattleBonuses.none,
    GameDifficulty difficulty = GameDifficulty.average,
  });
}
