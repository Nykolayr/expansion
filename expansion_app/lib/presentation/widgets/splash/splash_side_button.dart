import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:expansion/core/themes/expansion_text_styles.dart';
import 'package:expansion/presentation/widgets/splash/splash_menu_direct.dart';

/// Боковая кнопка меню splash (legacy `ButtonSide`).
class SplashSideButton extends StatelessWidget {
  const SplashSideButton({
    required this.direct,
    required this.title,
    required this.onPressed,
    required this.slotWidth,
    required this.slotHeight,
    super.key,
  });

  final SplashMenuDirect direct;
  final String title;
  final VoidCallback onPressed;
  final double slotWidth;
  final double slotHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: slotWidth,
        height: slotHeight,
        child: Stack(
          children: [
            Align(
              child: SvgPicture.asset(
                direct.svgPath(),
                fit: BoxFit.fill,
                width: slotWidth,
                height: slotHeight,
              ),
            ),
            Container(
              width: slotWidth,
              height: slotHeight,
              padding: EdgeInsets.only(
                left: direct.labelPaddingLeft,
                right: direct.isLabelLeft ? 0 : 8,
              ),
              child: Align(
                child: Text(
                  title,
                  style: ExpansionTextStyles.bodyAccent(context, 15).copyWith(
                    color: direct.labelColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
