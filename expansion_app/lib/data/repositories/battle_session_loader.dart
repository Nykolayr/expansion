import 'package:expansion/domain/entities/battle_layout.dart';
import 'package:expansion/domain/repositories/campaign_repository.dart';
import 'package:expansion/game_core/battle/battle_engine.dart';

class BattleSessionLoader {
  BattleSessionLoader(this._campaign);

  final CampaignRepository _campaign;

  Future<BattleEngine?> loadEngine(int sceneId) async {
    final layout = await _campaign.getBattleLayout(sceneId);
    if (layout == null) return null;
    return BattleEngine.fromLayout(layout);
  }

  Future<BattleLayout?> loadLayout(int sceneId) =>
      _campaign.getBattleLayout(sceneId);
}
