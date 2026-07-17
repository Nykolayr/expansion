import 'package:shared_preferences/shared_preferences.dart';

import 'package:expansion/core/constants/prefs_keys.dart';

/// Remote flags монетизации с VPS (`GET /expansion/config`).
///
/// Последний успешный ответ кэшируется в prefs — при офлайне не возвращаем fail-open `true`.
class RemoteMonetizationService {
  RemoteMonetizationService(this._prefs) {
    _loadCached();
  }

  final SharedPreferences _prefs;

  bool adsEnabled = true;
  bool donationsEnabled = true;
  bool _hasSuccessfulFetch = false;

  bool get hasSuccessfulFetch => _hasSuccessfulFetch;

  void _loadCached() {
    _hasSuccessfulFetch =
        _prefs.getBool(PrefsKeys.remoteMonetizationCached) ?? false;
    if (!_hasSuccessfulFetch) return;
    adsEnabled = _prefs.getBool(PrefsKeys.remoteAdsEnabled) ?? true;
    donationsEnabled = _prefs.getBool(PrefsKeys.remoteDonationsEnabled) ?? true;
  }

  void apply({required bool adsEnabled, required bool donationsEnabled}) {
    this.adsEnabled = adsEnabled;
    this.donationsEnabled = donationsEnabled;
    _hasSuccessfulFetch = true;
    _prefs
      ..setBool(PrefsKeys.remoteMonetizationCached, true)
      ..setBool(PrefsKeys.remoteAdsEnabled, adsEnabled)
      ..setBool(PrefsKeys.remoteDonationsEnabled, donationsEnabled);
  }

  /// Офлайн / ошибка сети: не включать рекламу обратно, если уже был успешный fetch.
  void keepCachedOrDefaults() {
    if (_hasSuccessfulFetch) {
      _loadCached();
      return;
    }
    adsEnabled = true;
    donationsEnabled = true;
  }
}
