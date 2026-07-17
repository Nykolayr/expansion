import 'dart:convert';

import 'package:expansion/core/constants/game_database_constants.dart';
import 'package:expansion/core/constants/game_layout.dart';
import 'package:expansion/data/models/battle_placement_row.dart';
import 'package:expansion/data/models/campaign_scene_row.dart';
import 'package:expansion/data/seed/campaign_snake_order.dart';
import 'package:expansion/domain/enums/neutral_base_kind.dart';
import 'package:expansion/domain/enums/neutral_base_variant.dart';
import 'package:expansion/domain/enums/placement_role.dart';
import 'package:expansion/domain/enums/scene_node_kind.dart';
import 'package:expansion/game_core/battle/neutral_base_balance.dart';

/// Парсинг bundled `scenes.json` и `objects_N.json` (camelCase legacy).
abstract final class SceneAssetParser {
  static List<CampaignSceneRow> parseScenesFromJsonList(
    List<dynamic> rawList, {
    int? maxMissions,
  }) {
    final cap = maxMissions ?? GameDatabaseConstants.campaignMissionCount;
    final count = rawList.length > cap ? cap : rawList.length;
    final snake = CampaignSnakeOrder.buildJsonIndices(count);
    final rows = <CampaignSceneRow>[];

    for (var order = 0; order < snake.length; order++) {
      final jsonIndex = snake[order];
      final item = rawList[jsonIndex] as Map<String, dynamic>;
      final missionId = jsonIndex + 1;
      final columnInRow = order % 5;

      rows.add(
        CampaignSceneRow(
          id: missionId,
          displayOrder: order,
          nameRu: item['nameRu'] as String? ?? '',
          nameEn: item['nameEn'] as String? ?? '',
          descriptionRu: item['descriptionRu'] as String? ?? '',
          descriptionEn: item['descriptionEn'] as String? ?? '',
          battleRu: item['battleRu'] as String? ?? '',
          battleEn: item['battleEn'] as String? ?? '',
          nodeKind: SceneNodeKind.forColumnIndex(columnInRow),
          gridRows: kBattleRows,
          gridCols: kBattleColumns,
        ),
      );
    }

    return rows;
  }

  static List<BattlePlacementRow> parseLayoutFromJson(
    int sceneId,
    Map<String, dynamic> json,
  ) {
    final placements = <BattlePlacementRow>[];

    void addMain(String key, PlacementRole role) {
      final block = json[key];
      if (block is! Map<String, dynamic>) return;
      final coords = block['coordinates'] as Map<String, dynamic>?;
      if (coords == null) return;
      placements.add(
        BattlePlacementRow(
          sceneId: sceneId,
          role: role,
          x: coords['x'] as int,
          y: coords['y'] as int,
          statsJson: encodeMainBaseStats(block),
        ),
      );
    }

    addMain('mainShipOur', PlacementRole.playerMain);
    addMain('mainShipEnemy', PlacementRole.enemyMain);

    final neutrals = json['neutral'];
    if (neutrals is List<dynamic>) {
      for (final item in neutrals) {
        if (item is! Map<String, dynamic>) continue;
        final coords = item['coordinates'] as Map<String, dynamic>?;
        if (coords == null) continue;
        final kind = NeutralBaseKind.fromLegacyType(
              item['typeNeutral'] as String?,
            );
        final variant = NeutralBaseVariant.fromLegacy(item['variant'] as String?);
        placements.add(
          BattlePlacementRow(
            sceneId: sceneId,
            role: PlacementRole.neutral,
            x: coords['x'] as int,
            y: coords['y'] as int,
            neutralKind: kind,
            statsJson: jsonEncode(
              NeutralBaseBalance.encodePlacement(
                kind: kind ?? NeutralBaseKind.smallBase,
                variant: variant,
                overrides: item,
              ),
            ),
          ),
        );
      }
    }

    return placements;
  }
}
