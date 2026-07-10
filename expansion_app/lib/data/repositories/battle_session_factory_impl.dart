import 'package:expansion/domain/entities/meta_battle_bonuses.dart';
import 'package:expansion/domain/enums/game_difficulty.dart';
import 'package:expansion/domain/repositories/campaign_repository.dart';
import 'package:expansion/game_core/battle/battle_engine.dart';
import 'package:expansion/game_core/battle/battle_session_factory.dart';

class BattleSessionFactoryImpl implements BattleSessionFactory {
  BattleSessionFactoryImpl(this._campaign);

  final CampaignRepository _campaign;

  @override
  Future<BattleEngine?> createEngine(
    int sceneId, {
    MetaBattleBonuses bonuses = MetaBattleBonuses.none,
    GameDifficulty difficulty = GameDifficulty.average,
  }) async {
    final layout = await _campaign.getBattleLayout(sceneId);
    if (layout == null) return null;
    return BattleEngine.fromLayout(
      layout,
      bonuses: bonuses,
      difficulty: difficulty,
    );
  }
}
