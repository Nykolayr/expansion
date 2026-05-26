import 'package:sqflite/sqflite.dart';

/// DDL локальной БД контента кампании.
abstract final class GameDatabaseMigrations {
  static const String tableContentMeta = 'content_meta';
  static const String tableCampaignScenes = 'campaign_scenes';
  static const String tableBattlePlacements = 'battle_placements';

  static Future<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableContentMeta (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        content_version INTEGER NOT NULL,
        seeded_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableCampaignScenes (
        id INTEGER PRIMARY KEY,
        display_order INTEGER NOT NULL,
        name_ru TEXT NOT NULL,
        name_en TEXT NOT NULL,
        description_ru TEXT NOT NULL,
        description_en TEXT NOT NULL,
        battle_ru TEXT NOT NULL,
        battle_en TEXT NOT NULL,
        node_kind TEXT NOT NULL,
        grid_rows INTEGER NOT NULL,
        grid_cols INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableBattlePlacements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        scene_id INTEGER NOT NULL,
        role TEXT NOT NULL,
        x INTEGER NOT NULL,
        y INTEGER NOT NULL,
        neutral_kind TEXT,
        stats_json TEXT,
        FOREIGN KEY (scene_id) REFERENCES $tableCampaignScenes (id)
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_campaign_scenes_order ON $tableCampaignScenes (display_order)',
    );
    await db.execute(
      'CREATE INDEX idx_battle_placements_scene ON $tableBattlePlacements (scene_id)',
    );
  }

  static Future<void> onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute('DROP TABLE IF EXISTS $tableBattlePlacements');
      await db.execute('DROP TABLE IF EXISTS $tableCampaignScenes');
      await db.execute('DROP TABLE IF EXISTS $tableContentMeta');
      await onCreate(db, newVersion);
    }
  }
}
