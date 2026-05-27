import 'package:flutter/material.dart';

import 'package:expansion/l10n/app_localizations.dart';
import 'package:expansion/presentation/widgets/splash/splash_menu_direct.dart';
import 'package:expansion/presentation/widgets/splash/splash_side_button.dart';

/// Ряд из трёх кнопок меню (legacy `LineButtons`).
class SplashLineButtons extends StatelessWidget {
  const SplashLineButtons({
    required this.isTop,
    required this.onMenuTap,
    this.continueEnabled = true,
    super.key,
  });

  final bool isTop;
  final void Function(SplashMenuDirect direct) onMenuTap;
  final bool continueEnabled;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final width = MediaQuery.sizeOf(context).width;
    final slotWidth = width / 3;
    final slotHeight = slotWidth / 3;

    final directs = isTop
        ? const [
            SplashMenuDirect.leftTop,
            SplashMenuDirect.middleTop,
            SplashMenuDirect.rightTop,
          ]
        : const [
            SplashMenuDirect.leftBottom,
            SplashMenuDirect.middleBottom,
            SplashMenuDirect.rightBottom,
          ];

    final titles = isTop
        ? [loc.splashMenuProfile, loc.splashMenuSettings, loc.splashMenuProgress]
        : [
            loc.splashMenuNewGame,
            loc.splashMenuUpgrades,
            loc.splashMenuContinue,
          ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      height: slotHeight,
      width: width,
      child: Stack(
        children: [
          for (var i = 0; i < 3; i++)
            Align(
              alignment: i == 0
                  ? Alignment.centerLeft
                  : i == 2
                      ? Alignment.centerRight
                      : Alignment.center,
              child: SplashSideButton(
                direct: directs[i],
                title: titles[i],
                slotWidth: slotWidth,
                slotHeight: slotHeight,
                enabled: directs[i] != SplashMenuDirect.rightBottom ||
                    continueEnabled,
                onPressed: () => onMenuTap(directs[i]),
              ),
            ),
        ],
      ),
    );
  }
}
