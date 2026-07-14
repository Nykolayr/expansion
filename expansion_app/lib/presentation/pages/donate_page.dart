import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/monetization/donate_billing_service.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';
import 'package:expansion/presentation/widgets/layout/game_menu_backdrop.dart';
import 'package:expansion/presentation/widgets/monetization/game_banner_ad_slot.dart';

/// Поддержка разработки: IAP-донаты и «убрать рекламу».
class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  var _busy = false;
  var _supporterTier = 0;
  var _adsRemoved = false;
  var _storeAvailable = false;

  @override
  void initState() {
    super.initState();
    _reload();
    _refreshStore();
  }

  Future<void> _reload() async {
    final guest = await sl<GuestProfileRepository>().load();
    final billing = sl<DonateBillingService>();
    if (!mounted) return;
    setState(() {
      _supporterTier = guest.supporterTier;
      _adsRemoved = guest.adsRemoved;
      _storeAvailable = billing.isStoreAvailable && billing.donationsEnabled;
    });
  }

  Future<void> _refreshStore() async {
    final billing = sl<DonateBillingService>();
    await billing.refreshProducts();
    if (!mounted) return;
    setState(() => _storeAvailable = billing.isStoreAvailable && billing.donationsEnabled);
  }

  Future<void> _purchase(DonateSku sku) async {
    if (_busy) return;
    setState(() => _busy = true);
    final loc = AppLocalizations.of(context)!;
    final ok = await sl<DonateBillingService>().purchase(sku);
    if (!mounted) return;
    setState(() => _busy = false);
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.donatePurchaseFailed)),
      );
      return;
    }
    await Future<void>.delayed(const Duration(seconds: 2));
    await _reload();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.donatePurchasePending)),
    );
  }

  Future<void> _restore() async {
    if (_busy) return;
    setState(() => _busy = true);
    await sl<DonateBillingService>().restorePurchases();
    await Future<void>.delayed(const Duration(seconds: 2));
    await _reload();
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.donateRestoreDone)),
    );
  }

  Future<void> _openLink(String url) async {
    final loc = AppLocalizations.of(context)!;
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.donateOpenFailed)),
      );
    }
  }

  String _tierLabel(AppLocalizations loc, DonateSku sku) {
    final billing = sl<DonateBillingService>();
    final price = billing.priceLabelFor(sku);
    return switch (sku) {
      DonateSku.tier1 => loc.donateTier1(price ?? loc.donatePriceFallback),
      DonateSku.tier2 => loc.donateTier2(price ?? loc.donatePriceFallback),
      DonateSku.tier3 => loc.donateTier3(price ?? loc.donatePriceFallback),
      DonateSku.removeAds =>
        loc.donateRemoveAds(price ?? loc.donatePriceFallback),
    };
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final billing = sl<DonateBillingService>();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const GameMenuBackdrop(),
          GameMenuTheme(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GameScreenBackBar(title: loc.donateTitle),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  children: [
                    Text(loc.donateBody, style: theme.textTheme.bodyLarge),
                    if (_supporterTier > 0) ...[
                      const Gap(16),
                      Card(
                        color: ExpansionColors.background.withValues(alpha: 0.92),
                        child: ListTile(
                          leading: Icon(
                            Icons.workspace_premium,
                            color: ExpansionColors.accent,
                            size: 32,
                          ),
                          title: Text(loc.donateSupporterStatus(_supporterTier)),
                          subtitle: Text(loc.donateSupporterHint),
                        ),
                      ),
                    ],
                    if (_adsRemoved) ...[
                      const Gap(12),
                      Text(
                        loc.donateAdsRemoved,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: ExpansionColors.accent,
                        ),
                      ),
                    ],
                    const Gap(24),
                    if (!_storeAvailable) ...[
                      Text(
                        billing.donationsEnabled
                            ? loc.donateStoreUnavailable
                            : loc.donateDisabledByAdmin,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ExpansionColors.grey,
                        ),
                      ),
                      const Gap(16),
                    ],
                    if (_storeAvailable) ...[
                      GameLongButton(
                        label: _tierLabel(loc, DonateSku.tier1),
                        onPressed: _busy
                            ? null
                            : () => _purchase(DonateSku.tier1),
                      ),
                      const Gap(12),
                      GameLongButton(
                        label: _tierLabel(loc, DonateSku.tier2),
                        onPressed: _busy
                            ? null
                            : () => _purchase(DonateSku.tier2),
                      ),
                      const Gap(12),
                      GameLongButton(
                        label: _tierLabel(loc, DonateSku.tier3),
                        onPressed: _busy
                            ? null
                            : () => _purchase(DonateSku.tier3),
                      ),
                      const Gap(12),
                      if (!_adsRemoved)
                        GameLongButton(
                          label: _tierLabel(loc, DonateSku.removeAds),
                          onPressed: _busy
                              ? null
                              : () => _purchase(DonateSku.removeAds),
                        ),
                      const Gap(12),
                      TextButton(
                        onPressed: _busy ? null : _restore,
                        child: Text(loc.donateRestore),
                      ),
                    ],
                    const Gap(16),
                    GameLongButton(
                      label: loc.donateGithub,
                      onPressed: () => _openLink(
                        'https://github.com/Nykolayr/expansion',
                      ),
                    ),
                    const Gap(12),
                    Text(
                      loc.donateThanks,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const GameBannerAdSlot(),
            ],
          ),
          ),
        ],
      ),
    );
  }
}
