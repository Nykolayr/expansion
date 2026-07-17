import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/monetization/game_ads_service.dart';
import 'package:expansion/presentation/services/expansion_platform_sync_service.dart';

/// Sticky-баннер внизу экрана (меню, настройки, карта). Не использовать в бою.
class GameBannerAdSlot extends StatefulWidget {
  const GameBannerAdSlot({super.key});

  @override
  State<GameBannerAdSlot> createState() => _GameBannerAdSlotState();
}

class _GameBannerAdSlotState extends State<GameBannerAdSlot> {
  BannerAd? _banner;
  StreamSubscription<BannerAdLoadState>? _loadSub;
  var _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initBanner());
  }

  Future<void> _initBanner() async {
    await sl<ExpansionPlatformSyncService>().refreshRemoteConfig();
    final ads = sl<GameAdsService>();
    if (!await ads.shouldShowAds() || !ads.isReady) return;
    if (!mounted) return;

    final width = MediaQuery.sizeOf(context).width.toInt();
    final adSize = BannerAdSize.sticky(width: width);
    final banner = BannerAd(adSize: adSize);

    _loadSub = banner.loadStateStream.listen((state) {
      if (!mounted) return;
      if (state is BannerAdLoadStateLoaded) {
        setState(() => _visible = true);
        unawaited(sl<ExpansionPlatformSyncService>().reportAdShown('banner'));
      } else if (state is BannerAdLoadStateError) {
        setState(() => _visible = false);
      }
    });

    banner.load(AdRequest(adUnitId: ads.bannerAdUnitId));
    setState(() => _banner = banner);
  }

  @override
  void dispose() {
    _loadSub?.cancel();
    _banner?.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible || _banner == null) {
      return const SizedBox.shrink();
    }
    return SafeArea(
      top: false,
      child: AdWidget(bannerAd: _banner!),
    );
  }
}
