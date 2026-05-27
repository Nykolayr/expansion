import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:expansion/core/constants/asset_paths.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/core/themes/expansion_text_styles.dart';

/// Широкая кнопка со скосом (`bottom_long.svg`) — стиль меню splash.
class GameLongButton extends StatelessWidget {
  const GameLongButton({
    required this.label,
    required this.onPressed,
    this.fontSize = 20,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width - 30;
    final enabled = onPressed != null;

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: GestureDetector(
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
                label,
                style: ExpansionTextStyles.bodyAccent(context, fontSize).copyWith(
                  color: enabled ? null : ExpansionColors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
