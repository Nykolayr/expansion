import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:expansion/core/constants/asset_paths.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';

/// Широкая кнопка «Начать игру» (legacy `ButtonLong`).
class SplashLongButton extends StatelessWidget {
  const SplashLongButton({
    required this.title,
    required this.onPressed,
    super.key,
  });

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width - 30;

    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              AssetPaths.svg('bottom_long.svg'),
              width: width,
              fit: BoxFit.fitWidth,
            ),
            Text(
              title,
              style: ExpansionTextStyles.bodyAccent(context, 20),
            ),
          ],
        ),
      ),
    );
  }
}
