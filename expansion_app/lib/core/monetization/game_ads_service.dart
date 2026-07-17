import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import 'package:expansion/core/constants/prefs_keys.dart';
import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/core/monetization/monetization_config.dart';
import 'package:expansion/core/monetization/remote_monetization_service.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/presentation/services/expansion_platform_sync_service.dart';

/// Обёртка над Yandex Mobile Ads: баннер, interstitial, rewarded.
class GameAdsService {
  GameAdsService(
    this._prefs,
    this._guestProfile,
    this._remoteMonetization,
    this._platformSync,
  );

  final SharedPreferences _prefs;
  final GuestProfileRepository _guestProfile;
  final RemoteMonetizationService _remoteMonetization;
  final ExpansionPlatformSyncService _platformSync;

  final _interstitialLoader = InterstitialAdLoader();
  final _rewardedLoader = RewardedAdLoader();

  InterstitialAd? _interstitial;
  RewardedAd? _rewarded;

  var _initialized = false;
  var _interstitialLoading = false;
  var _rewardedLoading = false;

  Future<void> init() async {
    if (kIsWeb || !(defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS)) {
      return;
    }
    try {
      await YandexAds.initialize();
      _initialized = true;
      AppLog.trace(
        'Yandex Mobile Ads initialized (demo=${MonetizationConfig.usesDemoAdUnits})',
        tag: 'Ads',
      );
      unawaited(preloadInterstitial());
      unawaited(preloadRewarded());
    } catch (e, st) {
      AppLog.error('Yandex Mobile Ads init failed', error: e, stackTrace: st, tag: 'Ads');
    }
  }

  Future<bool> shouldShowAds() async {
    if (!_remoteMonetization.adsEnabled) return false;
    if (!_initialized) return false;
    final guest = await _guestProfile.load();
    return !guest.adsRemoved;
  }

  Future<void> preloadInterstitial() async {
    if (!await shouldShowAds() || _interstitialLoading || _interstitial != null) {
      return;
    }
    _interstitialLoading = true;
    try {
      _interstitial = await _interstitialLoader.loadAd(
        adRequest: AdRequest(adUnitId: MonetizationConfig.interstitialAdUnitId),
      );
    } on AdRequestError catch (e) {
      _interstitial = null;
      AppLog.trace('interstitial load failed: ${e.description}', tag: 'Ads');
    } finally {
      _interstitialLoading = false;
    }
  }

  Future<void> preloadRewarded() async {
    if (!await shouldShowAds() || _rewardedLoading || _rewarded != null) {
      return;
    }
    _rewardedLoading = true;
    try {
      _rewarded = await _rewardedLoader.loadAd(
        adRequest: AdRequest(adUnitId: MonetizationConfig.rewardedAdUnitId),
      );
    } on AdRequestError catch (e) {
      _rewarded = null;
      AppLog.trace('rewarded load failed: ${e.description}', tag: 'Ads');
    } finally {
      _rewardedLoading = false;
    }
  }

  /// Показ interstitial при переходе бой → карта (с cooldown).
  Future<void> maybeShowInterstitialAfterBattle() async {
    if (!await shouldShowAds()) return;

    final battles = (_prefs.getInt(PrefsKeys.adsBattlesSinceInterstitial) ?? 0) + 1;
    await _prefs.setInt(PrefsKeys.adsBattlesSinceInterstitial, battles);

    final lastAt = _prefs.getInt(PrefsKeys.adsLastInterstitialMillis) ?? 0;
    final elapsed = DateTime.now().millisecondsSinceEpoch - lastAt;
    if (battles < MonetizationConfig.interstitialMinBattles) return;
    if (elapsed < MonetizationConfig.interstitialMinInterval.inMilliseconds) {
      return;
    }

    final shown = await _showInterstitial();
    if (shown) {
      await _prefs.setInt(PrefsKeys.adsBattlesSinceInterstitial, 0);
      await _prefs.setInt(
        PrefsKeys.adsLastInterstitialMillis,
        DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  Future<bool> _showInterstitial() async {
    final ad = _interstitial;
    if (ad == null) {
      await preloadInterstitial();
      return false;
    }
    try {
      ad.setAdEventListener(
        eventListener: InterstitialAdEventListener(
          onAdDismissed: () => AppLog.trace('interstitial dismissed', tag: 'Ads'),
        ),
      );
      await ad.show();
      await ad.waitForDismiss();
      unawaited(_platformSync.reportAdShown('interstitial'));
      return true;
    } catch (e, st) {
      AppLog.error('interstitial show failed', error: e, stackTrace: st, tag: 'Ads');
      return false;
    } finally {
      _interstitial?.destroy();
      _interstitial = null;
      unawaited(preloadInterstitial());
    }
  }

  /// Rewarded за +50% очков после победы. `true` — награда выдана.
  Future<bool> showVictoryRewardedAd() async {
    if (!await shouldShowAds()) return false;

    if (_rewarded == null) {
      await preloadRewarded();
    }
    final ad = _rewarded;
    if (ad == null) return false;

    var rewarded = false;
    final completer = Completer<bool>();

    ad.setAdEventListener(
      eventListener: RewardedAdEventListener(
        onRewarded: (_) => rewarded = true,
        onAdDismissed: () {
          if (!completer.isCompleted) completer.complete(rewarded);
        },
        onAdFailedToShow: (_) {
          if (!completer.isCompleted) completer.complete(false);
        },
      ),
    );

    try {
      await ad.show();
      final result = await ad.waitForDismiss();
      if (result != null) rewarded = true;
      if (rewarded) unawaited(_platformSync.reportAdShown('rewarded'));
      if (!completer.isCompleted) completer.complete(rewarded);
      return completer.future.timeout(
        const Duration(seconds: 1),
        onTimeout: () => rewarded,
      );
    } catch (e, st) {
      AppLog.error('rewarded show failed', error: e, stackTrace: st, tag: 'Ads');
      return false;
    } finally {
      _rewarded?.destroy();
      _rewarded = null;
      unawaited(preloadRewarded());
    }
  }

  String get bannerAdUnitId => MonetizationConfig.bannerAdUnitId;

  bool get isReady => _initialized;
}
