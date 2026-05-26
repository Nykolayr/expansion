import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'package:expansion/core/constants/game_database_constants.dart';
import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/data/datasources/local/game_database_migrations.dart';

class GameDatabase {
  Database? _db;

  Future<Database> get database async {
    final existing = _db;
    if (existing != null && existing.isOpen) {
      return existing;
    }
    _db = await _open();
    return _db!;
  }

  Future<void> close() async {
    final db = _db;
    _db = null;
    if (db != null && db.isOpen) {
      await db.close();
      AppLog.trace('game db closed', tag: 'GameDb');
    }
  }

  Future<Database> _open() async {
    final basePath = await getDatabasesPath();
    final path = p.join(basePath, GameDatabaseConstants.fileName);
    AppLog.trace('game db open path=$path', tag: 'GameDb');

    return openDatabase(
      path,
      version: GameDatabaseConstants.schemaVersion,
      onCreate: (Database db, int version) async {
        await GameDatabaseMigrations.onCreate(db, version);
        AppLog.trace('game db onCreate v=$version', tag: 'GameDb');
      },
      onUpgrade: GameDatabaseMigrations.onUpgrade,
    );
  }
}
