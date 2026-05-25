import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:expansion/core/themes/expansion_colors.dart';

/// Текстовые стили splash и игрового UI (из legacy `AppText`).
abstract final class ExpansionTextStyles {
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
    );
  }
}
