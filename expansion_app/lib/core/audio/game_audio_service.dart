import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expansion/core/constants/prefs_keys.dart';
import 'package:expansion/core/logging/app_log.dart';

/// Звуковые эффекты боя (ассеты в assets/audio/ — добавлять по мере переноса).
class GameAudioService {
  GameAudioService(this._prefs) : _player = AudioPlayer();

  final SharedPreferences _prefs;
  final AudioPlayer _player;

  bool get soundEnabled => _prefs.getBool(PrefsKeys.soundEnabled) ?? true;

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(PrefsKeys.soundEnabled, enabled);
  }

  Future<void> playFleetSend() => _play('audio/fleet_send.mp3');

  Future<void> playCapture() => _play('audio/capture.mp3');

  Future<void> playVictory() => _play('audio/victory.mp3');

  Future<void> playDefeat() => _play('audio/defeat.mp3');

  Future<void> _play(String asset) async {
    if (!soundEnabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource(asset));
    } catch (e) {
      AppLog.trace('audio skip $asset', tag: 'Audio');
    }
  }

  Future<void> dispose() => _player.dispose();
}
