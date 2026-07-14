import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:expansion/core/constants/prefs_keys.dart';
import 'package:expansion/core/device/device_id_service.dart';
import 'package:expansion/core/logging/app_log.dart';
import 'package:expansion/core/monetization/donate_billing_service.dart';
import 'package:expansion/core/monetization/monetization_config.dart';
import 'package:expansion/core/monetization/remote_monetization_service.dart';
import 'package:expansion/data/datasources/remote/expansion_platform_remote_datasource.dart';
import 'package:expansion/data/models/guest_profile_json_codec.dart';
import 'package:expansion/domain/repositories/auth_repository.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';

/// Синхронизация с VPS: remote config, гости, события монетизации.
class ExpansionPlatformSyncService {
  ExpansionPlatformSyncService(
    this._remote,
    this._deviceId,
    this._guestProfile,
    this._authRepository,
    this._remoteMonetization,
    this._prefs,
  );

  final ExpansionPlatformRemoteDataSource _remote;
  final DeviceIdService _deviceId;
  final GuestProfileRepository _guestProfile;
  final AuthRepository _authRepository;
  final RemoteMonetizationService _remoteMonetization;
  final SharedPreferences _prefs;

  Timer? _guestSyncTimer;
  var _guestSyncScheduled = false;

  Future<void> refreshRemoteConfig() async {
    try {
      final config = await _remote.fetchConfig();
      _remoteMonetization.apply(
        adsEnabled: config.adsEnabled,
        donationsEnabled: config.donationsEnabled,
      );
      AppLog.trace(
        'remote monetization ads=${config.adsEnabled} donations=${config.donationsEnabled}',
        tag: 'Platform',
      );
    } catch (e, st) {
      _remoteMonetization.resetToDefaults();
      AppLog.trace('remote config fallback (offline)', tag: 'Platform');
      AppLog.error('remote config failed', error: e, stackTrace: st, tag: 'Platform');
    }
  }

  void scheduleGuestSync() {
    if (_guestSyncScheduled) return;
    _guestSyncScheduled = true;
    _guestSyncTimer?.cancel();
    _guestSyncTimer = Timer(const Duration(seconds: 3), () async {
      _guestSyncScheduled = false;
      await syncGuestNow();
    });
  }

  Future<void> syncGuestNow() async {
    try {
      final guest = await _guestProfile.load();
      final benefits = await _remote.syncGuest(
        deviceId: _deviceId.getOrCreate(),
        profile: GuestProfileJsonCodec.toApi(guest),
      );
      if (benefits == null) return;

      var updated = guest;
      if (benefits.adsRemoved && !guest.adsRemoved) {
        updated = updated.copyWith(adsRemoved: true);
      }
      if (benefits.supporterTier > guest.supporterTier) {
        updated = updated.copyWith(supporterTier: benefits.supporterTier);
      }
      if (updated != guest) {
        await _guestProfile.save(updated);
        AppLog.trace(
          'guest benefits applied ads=${updated.adsRemoved} tier=${updated.supporterTier}',
          tag: 'Platform',
        );
      }
    } catch (e, st) {
      AppLog.trace('guest sync skipped (offline?)', tag: 'Platform');
      AppLog.error('guest sync failed', error: e, stackTrace: st, tag: 'Platform');
    }
  }

  Future<PaymentIntentResult?> createPaymentIntent({
    required String productId,
    String? ideaId,
  }) async {
    try {
      final guest = await _guestProfile.load();
      String? email;
      if (await _authRepository.isLoggedIn()) {
        final me = await _authRepository.fetchMe();
        email = me.fold((_) => null, (user) => user.email);
      }

      return await _remote.createPaymentIntent(
        deviceId: _deviceId.getOrCreate(),
        productId: productId,
        nick: guest.displayName.trim().isNotEmpty ? guest.displayName.trim() : null,
        email: email,
        ideaId: ideaId,
      );
    } catch (e, st) {
      AppLog.error('payment intent failed', error: e, stackTrace: st, tag: 'Platform');
      return null;
    }
  }

  Future<String?> submitDonationIdea({
    required String ideaText,
    String? guestEmail,
  }) async {
    try {
      final id = await _remote.submitDonationIdea(
        deviceId: _deviceId.getOrCreate(),
        ideaText: ideaText.trim(),
        email: guestEmail?.trim(),
      );
      await _prefs.setString(PrefsKeys.pendingDonationIdeaId, id);
      return id;
    } catch (e, st) {
      AppLog.error('donation idea failed', error: e, stackTrace: st, tag: 'Platform');
      return null;
    }
  }

  Future<void> reportPurchase(DonateSku sku, {double? priceRub}) async {
    await reportPurchaseByProductId(
      DonateBillingService.productIdFor(sku),
      priceRub: priceRub,
    );
  }

  Future<void> reportPurchaseByProductId(
    String productId, {
    double? priceRub,
  }) async {
    try {
      String? userId;
      if (await _authRepository.isLoggedIn()) {
        final me = await _authRepository.fetchMe();
        userId = me.fold((_) => null, (user) => user.id);
      }

      final pendingIdea = _prefs.getString(PrefsKeys.pendingDonationIdeaId);
      final isTier3 = productId == MonetizationConfig.productDonateTier3;
      final ideaId = isTier3 ? pendingIdea : null;
      final rub =
          priceRub ?? MonetizationConfig.priceRubFor(productId).toDouble();

      await _remote.reportPurchase(
        deviceId: _deviceId.getOrCreate(),
        productId: productId,
        store: _storeLabel,
        userId: userId,
        priceRub: rub > 0 ? rub : null,
        ideaId: ideaId,
      );

      if (isTier3 && ideaId != null) {
        await _prefs.remove(PrefsKeys.pendingDonationIdeaId);
      }
    } catch (e, st) {
      AppLog.error('purchase report failed', error: e, stackTrace: st, tag: 'Platform');
    }
  }

  Future<void> reportAdShown(String eventType) async {
    try {
      await _remote.reportAdEvents(
        deviceId: _deviceId.getOrCreate(),
        eventTypes: [eventType],
      );
    } catch (e, st) {
      AppLog.trace('ad report failed', tag: 'Platform');
      AppLog.error('ad report', error: e, stackTrace: st, tag: 'Platform');
    }
  }

  static String get _storeLabel {
    // Уточним при RuStore billing; пока Google Play / App Store через in_app_purchase.
    return 'in_app_purchase';
  }

  void dispose() {
    _guestSyncTimer?.cancel();
  }
}
