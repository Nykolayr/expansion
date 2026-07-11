import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expansion/core/constants/game_database_constants.dart';
import 'package:expansion/core/constants/prefs_keys.dart';
import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/data/datasources/local/campaign_local_datasource.dart';
import 'package:expansion/data/datasources/local/game_database.dart';
import 'package:expansion/data/seed/campaign_content_seeder.dart';
import 'package:expansion/presentation/bloc/bootstrap/app_bootstrap_state.dart';
import 'package:expansion/presentation/services/campaign_content_sync_service.dart';

/// Подготовка приложения: SQLite seed + OTA контент (offline-first).
class AppBootstrapCubit extends Cubit<AppBootstrapState> {
  AppBootstrapCubit(
    this._gameDatabase,
    this._contentSeeder,
    this._contentSync,
    this._local,
    this._prefs,
  ) : super(const AppBootstrapState.idle());

  final GameDatabase _gameDatabase;
  final CampaignContentSeeder _contentSeeder;
  final CampaignContentSyncService _contentSync;
  final CampaignLocalDataSource _local;
  final SharedPreferences _prefs;

  Future<void> initialize() async {
    if (state.isReady) {
      AppLog.trace('bootstrap skip (already ready)', tag: 'Bootstrap');
      return;
    }

    emit(state.copyWith(status: AppBootstrapStatus.loading));
    AppLog.trace('bootstrap start', tag: 'Bootstrap');

    try {
      await _gameDatabase.database;
      await _contentSeeder.seedIfNeeded();
      await _contentSync.syncIfNeeded();

      final storedVersion =
          await _local.getStoredContentVersion() ??
          GameDatabaseConstants.bundledContentVersion;
      final acknowledged =
          _prefs.getInt(PrefsKeys.lastAcknowledgedContentVersion) ?? 0;
      final showBanner = storedVersion >
              GameDatabaseConstants.bundledContentVersion &&
          storedVersion > acknowledged;

      emit(
        state.copyWith(
          status: AppBootstrapStatus.ready,
          contentVersion: storedVersion,
          showNewMissionsBanner: showBanner,
        ),
      );
      AppLog.trace(
        'bootstrap ready contentV=$storedVersion banner=$showBanner',
        tag: 'Bootstrap',
      );
    } catch (e, stackTrace) {
      AppLog.error(
        'bootstrap failed',
        error: e,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          status: AppBootstrapStatus.failed,
          errorMessage: e.toString(),
        ),
      );
      rethrow;
    }
  }

  Future<void> acknowledgeNewMissions() async {
    final version = state.contentVersion;
    if (version == null) return;
    await _prefs.setInt(PrefsKeys.lastAcknowledgedContentVersion, version);
    emit(state.copyWith(showNewMissionsBanner: false));
  }
}
