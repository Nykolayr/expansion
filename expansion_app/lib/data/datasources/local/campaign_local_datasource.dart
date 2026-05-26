import 'package:sqflite/sqflite.dart';

import 'package:expansion/data/datasources/local/game_database_migrations.dart';
import 'package:expansion/data/models/battle_placement_row.dart';
import 'package:expansion/data/models/campaign_scene_row.dart';

class CampaignLocalDataSource {
  CampaignLocalDataSource(this._db);

  final Future<Database> _db;

  Future<int?> getStoredContentVersion() async {
    final db = await _db;
    final rows = await db.query(GameDatabaseMigrations.tableContentMeta);
    if (rows.isEmpty) return null;
    return rows.first['content_version'] as int?;
  }

  Future<void> replaceAllContent({
    required int contentVersion,
    required List<CampaignSceneRow> scenes,
    required List<BattlePlacementRow> placements,
  }) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.delete(GameDatabaseMigrations.tableBattlePlacements);
      await txn.delete(GameDatabaseMigrations.tableCampaignScenes);
      await txn.delete(GameDatabaseMigrations.tableContentMeta);

      for (final scene in scenes) {
        await txn.insert(
          GameDatabaseMigrations.tableCampaignScenes,
          scene.toMap(),
        );
      }
      for (final placement in placements) {
        await txn.insert(
          GameDatabaseMigrations.tableBattlePlacements,
          placement.toMap(),
        );
      }

      await txn.insert(
        GameDatabaseMigrations.tableContentMeta,
        {
          'id': 1,
          'content_version': contentVersion,
          'seeded_at': DateTime.now().toUtc().toIso8601String(),
        },
      );
    });
  }

  Future<List<CampaignSceneRow>> fetchScenesOrdered() async {
    final db = await _db;
    final rows = await db.query(
      GameDatabaseMigrations.tableCampaignScenes,
      orderBy: 'display_order ASC',
    );
    return rows.map(CampaignSceneRow.fromMap).toList();
  }

  Future<List<BattlePlacementRow>> fetchPlacements(int sceneId) async {
    final db = await _db;
    final rows = await db.query(
      GameDatabaseMigrations.tableBattlePlacements,
      where: 'scene_id = ?',
      whereArgs: [sceneId],
    );
    return rows.map(BattlePlacementRow.fromMap).toList();
  }
}
