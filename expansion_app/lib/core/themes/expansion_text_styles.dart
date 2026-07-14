import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:expansion/core/themes/expansion_colors.dart';

/// Текстовые стили splash и игрового UI (из legacy `AppText`).
abstract final class ExpansionTextStyles {
  static const List<Shadow> menuTextShadows = [
    Shadow(
      offset: Offset(1, 1),
      blurRadius: 6,
      color: Color(0xCC000000),
    ),
    Shadow(
      offset: Offset(0, 0),
      blurRadius: 12,
      color: Color(0x80000000),
    ),
  ];

  static TextTheme menuTextTheme(TextTheme base) {
    TextStyle? withShadow(TextStyle? style) {
      if (style == null) return null;
      if (style.shadows != null && style.shadows!.isNotEmpty) return style;
      return style.copyWith(shadows: menuTextShadows);
    }

    return base.copyWith(
      displayLarge: withShadow(base.displayLarge),
      displayMedium: withShadow(base.displayMedium),
      displaySmall: withShadow(base.displaySmall),
      headlineLarge: withShadow(base.headlineLarge),
      headlineMedium: withShadow(base.headlineMedium),
      headlineSmall: withShadow(base.headlineSmall),
      titleLarge: withShadow(base.titleLarge),
      titleMedium: withShadow(base.titleMedium),
      titleSmall: withShadow(base.titleSmall),
      bodyLarge: withShadow(base.bodyLarge),
      bodyMedium: withShadow(base.bodyMedium),
      bodySmall: withShadow(base.bodySmall),
      labelLarge: withShadow(base.labelLarge),
      labelMedium: withShadow(base.labelMedium),
      labelSmall: withShadow(base.labelSmall),
    );
  }

  static TextStyle titleAccent(BuildContext context, double fontSize) {
    return GoogleFonts.kellySlab(
      color: ExpansionColors.accent,
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
      shadows: const [
        Shadow(
          offset: Offset(2, 2),
          blurRadius: 10,
          color: ExpansionColors.black,
        ),
      ],
    );
  }

  static TextStyle bodyAccent(BuildContext context, double fontSize) {
    return GoogleFonts.kellySlab(
      color: ExpansionColors.accent,
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
    );
  }

  static TextStyle bodyOnDark(BuildContext context, double fontSize) {
    return GoogleFonts.kellySlab(
      color: ExpansionColors.white,
      fontWeight: FontWeight.w400,
      fontSize: fontSize,
      shadows: menuTextShadows,
    );
  }
}
