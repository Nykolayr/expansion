import 'package:expansion/core/constants/game_database_constants.dart';
import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/data/datasources/local/campaign_local_datasource.dart';
import 'package:expansion/data/datasources/remote/campaign_content_remote_datasource.dart';
import 'package:expansion/data/models/battle_placement_row.dart';
import 'package:expansion/data/seed/scene_asset_parser.dart';
import 'package:expansion/domain/repositories/auth_repository.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/presentation/services/profile_sync_service.dart';

class CampaignContentSyncResult {
  const CampaignContentSyncResult({
    required this.updated,
    this.newContentVersion,
  });

  final bool updated;
  final int? newContentVersion;
}

/// Проверка OTA-контента и merge в SQLite. Офлайн — играем из локального кэша.
class CampaignContentSyncService {
  CampaignContentSyncService(
    this._remote,
    this._local,
    this._auth,
    this._guest,
    this._profileSync,
  );

  final CampaignContentRemoteDataSource _remote;
  final CampaignLocalDataSource _local;
  final AuthRepository _auth;
  final GuestProfileRepository _guest;
  final ProfileSyncService _profileSync;

  Future<CampaignContentSyncResult> syncIfNeeded() async {
    final localVersion =
        await _local.getStoredContentVersion() ??
        GameDatabaseConstants.bundledContentVersion;

    final remoteInfo = await _remote.fetchVersion();
    if (remoteInfo == null) {
      AppLog.trace('content OTA skip (offline)', tag: 'ContentOTA');
      await _flushProfileIfOnline();
      return const CampaignContentSyncResult(updated: false);
    }

    if (remoteInfo.contentVersion <= localVersion) {
      AppLog.trace(
        'content OTA up to date local=$localVersion remote=${remoteInfo.contentVersion}',
        tag: 'ContentOTA',
      );
      await _flushProfileIfOnline();
      return const CampaignContentSyncResult(updated: false);
    }

    try {
      final pack = await _remote.fetchPack();
      if (pack == null) {
        return const CampaignContentSyncResult(updated: false);
      }

      final packVersion = CampaignContentPackParser.readVersion(pack);
      if (packVersion <= localVersion) {
        return const CampaignContentSyncResult(updated: false);
      }

      final scenesRaw = CampaignContentPackParser.decodeScenesList(pack);
      final scenes = SceneAssetParser.parseScenesFromJsonList(scenesRaw);

      final layoutsMap = CampaignContentPackParser.decodeLayouts(pack);
      final placements = <BattlePlacementRow>[];
      for (final entry in layoutsMap.entries) {
        final sceneId = int.tryParse(entry.key);
        final layoutJson = entry.value;
        if (sceneId == null || layoutJson is! Map<String, dynamic>) continue;
        placements.addAll(
          SceneAssetParser.parseLayoutFromJson(sceneId, layoutJson),
        );
      }

      await _local.mergeRemoteContent(
        contentVersion: packVersion,
        scenes: scenes,
        placements: placements,
      );

      AppLog.trace(
        'content OTA merged v$packVersion scenes=${scenes.length} layouts=${layoutsMap.length}',
        tag: 'ContentOTA',
      );

      await _flushProfileIfOnline();

      return CampaignContentSyncResult(
        updated: true,
        newContentVersion: packVersion,
      );
    } catch (e, stackTrace) {
      AppLog.error(
        'content OTA failed',
        tag: 'ContentOTA',
        error: e,
        stackTrace: stackTrace,
      );
      await _flushProfileIfOnline();
      return const CampaignContentSyncResult(updated: false);
    }
  }

  /// При появлении сети — отправить локальный прогресс на сервер (если аккаунт).
  Future<void> _flushProfileIfOnline() async {
    if (!await _auth.isLoggedIn()) return;
    try {
      final profile = await _guest.load();
      await _profileSync.pushNow(profile);
    } catch (e, stackTrace) {
      AppLog.error(
        'profile flush on connect failed',
        tag: 'ContentOTA',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
