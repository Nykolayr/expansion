import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:expansion/core/constants/prefs_keys.dart';

/// Стабильный идентификатор устройства для гостей (не IMEI).
class DeviceIdService {
  DeviceIdService(this._prefs);

  final SharedPreferences _prefs;
  static const _uuid = Uuid();

  String getOrCreate() {
    final existing = _prefs.getString(PrefsKeys.deviceId);
    if (existing != null && existing.length >= 8) return existing;
    final id = _uuid.v4();
    _prefs.setString(PrefsKeys.deviceId, id);
    return id;
  }
}
