import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:expansion/core/di/injection_container.dart';
import 'package:expansion/core/monetization/donate_billing_service.dart';
import 'package:expansion/core/monetization/monetization_config.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/repositories/guest_profile_repository.dart';
import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/services/expansion_platform_sync_service.dart';
import 'package:expansion/presentation/widgets/app_bar/game_screen_back_bar.dart';
import 'package:expansion/presentation/widgets/buttons/game_long_button.dart';
import 'package:expansion/presentation/widgets/dialogs/donate_idea_dialog.dart';
import 'package:expansion/presentation/widgets/layout/game_menu_backdrop.dart';
import 'package:expansion/presentation/widgets/monetization/game_banner_ad_slot.dart';

/// Поддержка разработки: донаты и «убрать рекламу».
class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  var _supporterTier = 0;
  var _adsRemoved = false;
  var _donationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    await sl<ExpansionPlatformSyncService>().refreshRemoteConfig();
    final guest = await sl<GuestProfileRepository>().load();
    final billing = sl<DonateBillingService>();
    if (!mounted) return;
    setState(() {
      _supporterTier = guest.supporterTier;
      _adsRemoved = guest.adsRemoved;
      _donationsEnabled = billing.donationsEnabled;
    });
  }

  Future<void> _startPayment(DonateSku sku) async {
    if (!_donationsEnabled) return;
    await context.push('/donate/payment', extra: sku);
    await _reload();
  }

  Future<void> _startTier3() async {
    final ideaId = await showDonateIdeaDialog(context);
    if (!mounted || ideaId == null) return;
    await _startPayment(DonateSku.tier3);
  }

  String _tierLabel(AppLocalizations loc, DonateSku sku) {
    final price = MonetizationConfig.priceLabelRub(
      switch (sku) {
        DonateSku.tier1 => MonetizationConfig.priceTier1Rub,
        DonateSku.tier2 => MonetizationConfig.priceTier2Rub,
        DonateSku.tier3 => MonetizationConfig.priceTier3Rub,
        DonateSku.removeAds => MonetizationConfig.priceRemoveAdsRub,
      },
    );
    return switch (sku) {
      DonateSku.tier1 => loc.donateTier1(price),
      DonateSku.tier2 => loc.donateTier2(price),
      DonateSku.tier3 => loc.donateTier3(price),
      DonateSku.removeAds => loc.donateRemoveAds(price),
    };
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

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
                      Text(
                        loc.donateBody(loc.appTitle),
                        style: theme.textTheme.bodyLarge,
                      ),
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
                      if (!_donationsEnabled) ...[
                        Text(
                          loc.donateDisabledByAdmin,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ExpansionColors.grey,
                          ),
                        ),
                      ] else ...[
                        GameLongButton(
                          label: _tierLabel(loc, DonateSku.tier1),
                          onPressed: () => _startPayment(DonateSku.tier1),
                        ),
                        const Gap(12),
                        GameLongButton(
                          label: _tierLabel(loc, DonateSku.tier2),
                          onPressed: () => _startPayment(DonateSku.tier2),
                        ),
                        const Gap(12),
                        GameLongButton(
                          label: _tierLabel(loc, DonateSku.tier3),
                          onPressed: _startTier3,
                        ),
                        const Gap(8),
                        Text(
                          loc.donateIdeaHint,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ExpansionColors.grey,
                          ),
                        ),
                        const Gap(12),
                        if (!_adsRemoved)
                          GameLongButton(
                            label: _tierLabel(loc, DonateSku.removeAds),
                            onPressed: () => _startPayment(DonateSku.removeAds),
                          ),
                      ],
                      const Gap(16),
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
