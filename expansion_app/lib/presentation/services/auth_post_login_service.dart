import 'package:expansion/data/datasources/remote/profile_remote_datasource.dart';
import 'package:expansion/domain/entities/guest_profile.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/presentation/services/profile_sync_service.dart';

enum ProgressMergeChoice { keepLocal, keepServer }

/// После login/register: синхронизация локального и серверного профиля.
class AuthPostLoginService {
  AuthPostLoginService(this._guest, this._profileRemote, this._sync);

  final GuestProfileRepository _guest;
  final ProfileRemoteDataSource _profileRemote;
  final ProfileSyncService _sync;

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
        await pushLocalProfile(local, realName: realName);
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
    final local = await loadLocalProfile();
    final server = await fetchServerProfile();

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

    await pushLocalProfile(local, realName: realName);
    if (realName != null && realName.trim().isNotEmpty) {
      final name = realName.trim();
      if (local.displayName != name) {
        await _saveLocalPaused(local.copyWith(displayName: name));
      }
    }
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
