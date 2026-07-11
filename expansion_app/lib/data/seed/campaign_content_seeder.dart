import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:expansion/core/constants/game_database_constants.dart';
import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/data/datasources/local/campaign_local_datasource.dart';
import 'package:expansion/data/models/battle_placement_row.dart';
import 'package:expansion/data/seed/scene_asset_parser.dart';

/// Загрузка bundled baseline (м1–м5 offline) в SQLite при bootstrap.
/// Миссии м6+ — через OTA с сервера, см. docs/campaign-content-ota.md.
class CampaignContentSeeder {
  CampaignContentSeeder(this._local);

  final CampaignLocalDataSource _local;

  static const String _scenesAsset = 'assets/scenes/scenes.json';

  Future<void> seedIfNeeded() async {
    final stored = await _local.getStoredContentVersion();
    if (stored == GameDatabaseConstants.bundledContentVersion) {
      AppLog.trace(
        'content seed skip v=$stored',
        tag: 'ContentSeed',
      );
      return;
    }

    AppLog.trace('content seed start', tag: 'ContentSeed');
    final scenesJson = await rootBundle.loadString(_scenesAsset);
    final rawList = jsonDecode(scenesJson) as List<dynamic>;
    final scenes = SceneAssetParser.parseScenesFromJsonList(rawList);

    final placements = <BattlePlacementRow>[];
    for (final scene in scenes) {
      final path = 'assets/scenes/objects_${scene.id}.json';
      try {
        final layoutJson = await rootBundle.loadString(path);
        final map = jsonDecode(layoutJson) as Map<String, dynamic>;
        placements.addAll(
          SceneAssetParser.parseLayoutFromJson(scene.id, map),
        );
      } catch (e) {
        AppLog.error(
          'missing layout $path',
          tag: 'ContentSeed',
          error: e,
        );
      }
    }

    await _local.replaceAllContent(
      contentVersion: GameDatabaseConstants.bundledContentVersion,
      scenes: scenes,
      placements: placements,
    );

    AppLog.trace(
      'content seed done scenes=${scenes.length} placements=${placements.length}',
      tag: 'ContentSeed',
    );
  }
}
