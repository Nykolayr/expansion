import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/data/datasources/remote/profile_remote_datasource.dart';
import 'package:expansion/domain/entities/guest_profile.dart';
import 'package:expansion/domain/repositories/auth_repository.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/presentation/services/profile_sync_service.dart';

enum ProgressMergeChoice { keepLocal, keepServer }

/// После login/register: синхронизация локального и серверного профиля.
class AuthPostLoginService {
  AuthPostLoginService(this._auth, this._guest, this._profileRemote, this._sync);

  final AuthRepository _auth;
  final GuestProfileRepository _guest;
  final ProfileRemoteDataSource _profileRemote;
  final ProfileSyncService _sync;

  /// Холодный старт: refresh JWT, подтянуть профиль с сервера или отправить локальный.
  Future<void> syncOnColdStart() async {
    if (!await _auth.isLoggedIn()) return;

    final refresh = await _auth.refreshSession();
    if (refresh.isLeft()) {
      AppLog.trace('bootstrap auth skip (session expired)', tag: 'AuthBootstrap');
      return;
    }

    try {
      var local = await loadLocalProfile();
      final server = await fetchServerProfile();
      local = await _applyServerAdsRemovedIfNeeded(local: local, server: server);

      if (needsMergeChoice(local: local, server: server)) {
        await pushLocalProfile(
          _profileWithMergedAdsRemoved(local: local, server: server),
        );
        return;
      }

      await syncAfterAuth();
    } catch (e, stackTrace) {
      AppLog.error(
        'bootstrap profile sync failed',
        tag: 'AuthBootstrap',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> applyServerProfile(GuestProfile serverProfile) async {
    _sync.pause();
    try {
      await _guest.save(serverProfile);
    } finally {
      _sync.resume();
    }
  }

  Future<void> pushLocalProfile(GuestProfile local, {String? realName}) async {
    _sync.pause();
    try {
      await _profileRemote.updateProfile(local, realName: realName);
    } finally {
      _sync.resume();
    }
  }

  Future<GuestProfile> fetchServerProfile() => _profileRemote.fetchProfile();

  Future<GuestProfile> loadLocalProfile() => _guest.load();

  bool needsMergeChoice({
    required GuestProfile local,
    required GuestProfile server,
  }) {
    return local.hasCampaignProgress && server.hasCampaignProgress;
  }

  Future<void> applyMergeChoice({
    required ProgressMergeChoice choice,
    required GuestProfile local,
    required GuestProfile server,
    String? realName,
  }) async {
    switch (choice) {
      case ProgressMergeChoice.keepLocal:
        await pushLocalProfile(
          _profileWithMergedAdsRemoved(local: local, server: server),
          realName: realName,
        );
        if (realName != null && realName.trim().isNotEmpty) {
          await _saveLocalPaused(local.copyWith(displayName: realName.trim()));
        }
      case ProgressMergeChoice.keepServer:
        await applyServerProfile(server);
    }
  }

  Future<void> syncAfterAuth({
    ProgressMergeChoice? forcedChoice,
    String? realName,
  }) async {
    var local = await loadLocalProfile();
    final server = await fetchServerProfile();
    local = await _applyServerAdsRemovedIfNeeded(local: local, server: server);

    if (forcedChoice != null &&
        needsMergeChoice(local: local, server: server)) {
      await applyMergeChoice(
        choice: forcedChoice,
        local: local,
        server: server,
        realName: realName,
      );
      return;
    }

    if (needsMergeChoice(local: local, server: server)) {
      return;
    }

    if (server.hasCampaignProgress && !local.hasCampaignProgress) {
      await applyServerProfile(server);
      return;
    }

    final trimmedRealName = realName?.trim() ?? '';
    if (trimmedRealName.isNotEmpty && local.displayName.trim().isEmpty) {
      local = local.copyWith(displayName: trimmedRealName);
      await _saveLocalPaused(local);
    }

    await pushLocalProfile(
      _profileWithMergedAdsRemoved(local: local, server: server),
      realName: trimmedRealName.isEmpty ? null : trimmedRealName,
    );
  }

  GuestProfile _profileWithMergedAdsRemoved({
    required GuestProfile local,
    required GuestProfile server,
  }) {
    if (local.adsRemoved || server.adsRemoved) {
      return local.copyWith(adsRemoved: true);
    }
    return local;
  }

  Future<GuestProfile> _applyServerAdsRemovedIfNeeded({
    required GuestProfile local,
    required GuestProfile server,
  }) async {
    final merged = _profileWithMergedAdsRemoved(local: local, server: server);
    if (merged.adsRemoved != local.adsRemoved) {
      await _saveLocalPaused(merged);
    }
    return merged;
  }

  Future<void> _saveLocalPaused(GuestProfile profile) async {
    _sync.pause();
    try {
      await _guest.save(profile);
    } finally {
      _sync.resume();
    }
  }
}
