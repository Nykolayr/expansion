import 'package:expansion/core/constants/game_database_constants.dart';
import 'package:expansion/data/datasources/local/campaign_local_datasource.dart';
import 'package:expansion/data/models/campaign_scene_row.dart';
import 'package:expansion/domain/entities/battle_layout.dart';
import 'package:expansion/domain/entities/campaign_scene.dart';
import 'package:expansion/domain/repositories/campaign_repository.dart';

class CampaignRepositoryImpl implements CampaignRepository {
  CampaignRepositoryImpl(this._local);

  final CampaignLocalDataSource _local;

  @override
  Future<int> getBundledContentVersion() async {
    return GameDatabaseConstants.bundledContentVersion;
  }

  @override
  Future<List<CampaignScene>> getCampaignScenes() async {
    final rows = await _local.fetchScenesOrdered();
    return rows.map((r) => r.toEntity()).toList();
  }

  @override
  Future<BattleLayout?> getBattleLayout(int sceneId) async {
    final scenes = await _local.fetchScenesOrdered();
    CampaignSceneRow? scene;
    for (final row in scenes) {
      if (row.id == sceneId) {
        scene = row;
        break;
      }
    }
    if (scene == null) return null;

    final placements = await _local.fetchPlacements(sceneId);
    return BattleLayout(
      sceneId: sceneId,
      gridRows: scene.gridRows,
      gridCols: scene.gridCols,
      placements: placements.map((p) => p.toEntity()).toList(),
    );
  }
}
