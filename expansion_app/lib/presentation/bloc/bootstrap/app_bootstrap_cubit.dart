import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expansion/core/constants/game_database_constants.dart';
import 'package:expansion/core/constants/prefs_keys.dart';
import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/core/monetization/donate_billing_service.dart';
import 'package:expansion/core/monetization/game_ads_service.dart';
import 'package:expansion/data/datasources/local/campaign_local_datasource.dart';
import 'package:expansion/data/datasources/local/game_database.dart';
import 'package:expansion/data/seed/campaign_content_seeder.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/presentation/bloc/bootstrap/app_bootstrap_state.dart';
import 'package:expansion/presentation/services/auth_post_login_service.dart';
import 'package:expansion/presentation/services/campaign_content_sync_service.dart';
import 'package:expansion/presentation/services/expansion_platform_sync_service.dart';

/// Подготовка приложения: SQLite seed + OTA контент (offline-first).
class AppBootstrapCubit extends Cubit<AppBootstrapState> {
  AppBootstrapCubit(
    this._gameDatabase,
    this._contentSeeder,
    this._contentSync,
    this._local,
    this._prefs,
    this._guestProfile,
    this._platformSync,
    this._authPostLogin,
    this._ads,
    this._billing,
  ) : super(const AppBootstrapState.idle());

  final GameDatabase _gameDatabase;
  final CampaignContentSeeder _contentSeeder;
  final CampaignContentSyncService _contentSync;
  final CampaignLocalDataSource _local;
  final SharedPreferences _prefs;
  final GuestProfileRepository _guestProfile;
  final ExpansionPlatformSyncService _platformSync;
  final AuthPostLoginService _authPostLogin;
  final GameAdsService _ads;
  final DonateBillingService _billing;

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
      await _platformSync.refreshRemoteConfig();
      await Future.wait<void>([
        _platformSync.syncGuestNow(),
        _authPostLogin.syncOnColdStart(),
        _ads.init(),
        _billing.init(),
      ]);

      final storedVersion =
          await _local.getStoredContentVersion() ??
          GameDatabaseConstants.bundledContentVersion;
      final acknowledged =
          _prefs.getInt(PrefsKeys.lastAcknowledgedContentVersion) ?? 0;
      final guest = await _guestProfile.load();
      final hasCompletedMission = guest.mapClassic > 1;
      final showBanner = hasCompletedMission &&
          storedVersion > GameDatabaseConstants.bundledContentVersion &&
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
