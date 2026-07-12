import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expansion/core/constants/prefs_keys.dart';
import 'package:expansion/core/logging/app_log.dart';

/// Звуковые эффекты боя (ассеты в assets/audio/ — добавлять по мере переноса).
class GameAudioService {
  GameAudioService(this._prefs)
      : _player = AudioPlayer(),
        _fleetSendPlayers = List.generate(_fleetSendPoolSize, (_) => AudioPlayer()),
        _fleetClashPlayers =
            List.generate(_fleetClashPoolSize, (_) => AudioPlayer()),
        _hazardSpawnPlayers =
            List.generate(_hazardPoolSize, (_) => AudioPlayer()),
        _hazardPassPlayers =
            List.generate(_hazardPoolSize, (_) => AudioPlayer()),
        _uiClickPlayers = List.generate(_uiClickPoolSize, (_) => AudioPlayer());

  static const _fleetSendPoolSize = 4;
  static const _fleetClashPoolSize = 3;
  static const _hazardPoolSize = 2;
  static const _uiClickPoolSize = 4;
  static const _hazardSpawnMinGap = Duration(milliseconds: 350);
  static const _uiClickMinGap = Duration(milliseconds: 60);

  final SharedPreferences _prefs;
  final AudioPlayer _player;
  final List<AudioPlayer> _fleetSendPlayers;
  final List<AudioPlayer> _fleetClashPlayers;
  final List<AudioPlayer> _hazardSpawnPlayers;
  final List<AudioPlayer> _hazardPassPlayers;
  final List<AudioPlayer> _uiClickPlayers;
  int _fleetSendIndex = 0;
  int _fleetClashIndex = 0;
  int _hazardSpawnIndex = 0;
  int _hazardPassIndex = 0;
  int _uiClickIndex = 0;
  DateTime? _lastHazardSpawnAt;
  DateTime? _lastUiClickAt;

  bool get soundEnabled => _prefs.getBool(PrefsKeys.soundEnabled) ?? true;

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(PrefsKeys.soundEnabled, enabled);
  }

  /// Отправка флота — отдельный пул: при быстрых кликах звуки накладываются (~1 с каждый).
  Future<void> playFleetSend() async {
    await _playPooled('audio/fleet_send.mp3', _fleetSendPlayers, () {
      final i = _fleetSendIndex;
      _fleetSendIndex = (_fleetSendIndex + 1) % _fleetSendPoolSize;
      return i;
    });
  }

  /// Столкновение двух враждебных флотов в полёте.
  Future<void> playFleetClash() async {
    await _playPooled('audio/fleet_clash.mp3', _fleetClashPlayers, () {
      final i = _fleetClashIndex;
      _fleetClashIndex = (_fleetClashIndex + 1) % _fleetClashPoolSize;
      return i;
    });
  }

  /// Появление hazard на поле (астероид, комета, обломки…).
  Future<void> playHazardSpawn() async {
    if (!soundEnabled) return;
    final now = DateTime.now();
    if (_lastHazardSpawnAt != null &&
        now.difference(_lastHazardSpawnAt!) < _hazardSpawnMinGap) {
      return;
    }
    _lastHazardSpawnAt = now;
    await _playPooled('audio/hazard_spawn.mp3', _hazardSpawnPlayers, () {
      final i = _hazardSpawnIndex;
      _hazardSpawnIndex = (_hazardSpawnIndex + 1) % _hazardPoolSize;
      return i;
    });
  }

  /// Пролёт hazard через карту (через ~0.4 с после появления).
  Future<void> playHazardPass() async {
    await _playPooled('audio/hazard_pass.mp3', _hazardPassPlayers, () {
      final i = _hazardPassIndex;
      _hazardPassIndex = (_hazardPassIndex + 1) % _hazardPoolSize;
      return i;
    });
  }

  /// Sci-fi бип UI: кнопки меню, треугольники апгрейда.
  Future<void> playUiClick() async {
    if (!soundEnabled) return;
    final now = DateTime.now();
    if (_lastUiClickAt != null &&
        now.difference(_lastUiClickAt!) < _uiClickMinGap) {
      return;
    }
    _lastUiClickAt = now;
    await _playPooled('audio/ui_click.mp3', _uiClickPlayers, () {
      final i = _uiClickIndex;
      _uiClickIndex = (_uiClickIndex + 1) % _uiClickPoolSize;
      return i;
    });
  }

  /// Sci-fi подтверждение покупки апгрейда.
  Future<void> playUpgrade() => _play('audio/upgrade.mp3');

  Future<void> playCapture() => _play('audio/capture.mp3');

  Future<void> playVictory() => _play('audio/victory.mp3');

  Future<void> playDefeat() => _play('audio/defeat.mp3');

  Future<void> _playPooled(
    String asset,
    List<AudioPlayer> pool,
    int Function() nextIndex,
  ) async {
    if (!soundEnabled) return;
    final player = pool[nextIndex()];
    try {
      await player.play(AssetSource(asset));
    } catch (e) {
      AppLog.trace('audio skip $asset', tag: 'Audio');
    }
  }

  Future<void> _play(String asset) async {
    if (!soundEnabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource(asset));
    } catch (e) {
      AppLog.trace('audio skip $asset', tag: 'Audio');
    }
  }

  Future<void> dispose() async {
    await _player.dispose();
    for (final player in [
      ..._fleetSendPlayers,
      ..._fleetClashPlayers,
      ..._hazardSpawnPlayers,
      ..._hazardPassPlayers,
      ..._uiClickPlayers,
    ]) {
      await player.dispose();
    }
  }
}
