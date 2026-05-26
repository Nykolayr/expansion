import 'package:expansion/domain/entities/battle_layout.dart';
import 'package:expansion/domain/entities/campaign_scene.dart';

abstract class CampaignRepository {
  Future<List<CampaignScene>> getCampaignScenes();

  Future<BattleLayout?> getBattleLayout(int sceneId);

  Future<int> getBundledContentVersion();
}
