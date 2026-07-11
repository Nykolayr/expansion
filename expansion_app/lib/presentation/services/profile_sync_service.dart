import 'dart:async';

import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/data/datasources/remote/profile_remote_datasource.dart';
import 'package:expansion/domain/entities/guest_profile.dart';
import 'package:expansion/domain/repositories/auth_repository.dart';

/// Debounced `PUT /profile` для залогиненных пользователей.
class ProfileSyncService {
  ProfileSyncService(this._auth, this._remote);

  static const Duration debounce = Duration(seconds: 2);

  final AuthRepository _auth;
  final ProfileRemoteDataSource _remote;

  int _pauseDepth = 0;
  Timer? _timer;
  GuestProfile? _pending;
  Future<void>? _inFlight;

  void pause() => _pauseDepth++;

  void resume() {
    if (_pauseDepth > 0) {
      _pauseDepth--;
    }
  }

  /// Вызывается после локального сохранения прогресса.
  void schedulePush(GuestProfile profile) {
    if (_pauseDepth > 0) return;

    _pending = profile;
    _timer?.cancel();
    _timer = Timer(debounce, () {
      unawaited(_flush());
    });
  }

  /// Немедленная отправка (после auth merge и т.п.).
  Future<void> pushNow(GuestProfile profile) async {
    _pending = profile;
    _timer?.cancel();
    await _flush();
  }

  Future<void> _flush() async {
    if (_pauseDepth > 0) return;

    final profile = _pending;
    _pending = null;
    if (profile == null) return;

    if (!await _auth.isLoggedIn()) return;

    if (_inFlight != null) {
      await _inFlight;
      if (_pending != null) {
        await _flush();
      }
      return;
    }

    _inFlight = _push(profile);
    try {
      await _inFlight;
    } finally {
      _inFlight = null;
    }
  }

  Future<void> _push(GuestProfile profile) async {
    try {
      final realName = profile.displayName.trim();
      await _remote.updateProfile(
        profile,
        realName: realName.isEmpty ? null : realName,
      );
      AppLog.trace('profile synced to server', tag: 'ProfileSync');
    } catch (e, stackTrace) {
      AppLog.error(
        'profile sync failed',
        tag: 'ProfileSync',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}
