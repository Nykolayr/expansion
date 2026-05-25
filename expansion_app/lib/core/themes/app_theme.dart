import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:expansion/core/themes/expansion_colors.dart';

/// Material 3 — тёмная космическая тема (палитра из legacy Expansion).
abstract final class AppTheme {
  static const Color semanticSuccess = ExpansionColors.green;
  static const Color semanticWarning = ExpansionColors.accent;
  static const Color semanticError = ExpansionColors.red;
  static const Color onSemanticSolid = ExpansionColors.white;
  static const Color onSemanticWarningText = ExpansionColors.black;

  static ThemeData game() {
    final scheme = ColorScheme.fromSeed(
      seedColor: ExpansionColors.background,
      brightness: Brightness.dark,
      primary: ExpansionColors.accent,
      onPrimary: ExpansionColors.black,
      surface: ExpansionColors.background,
      onSurface: ExpansionColors.white,
      secondary: ExpansionColors.blue,
      error: ExpansionColors.red,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: ExpansionColors.background,
      canvasColor: ExpansionColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: ExpansionColors.background,
        foregroundColor: ExpansionColors.white,
        centerTitle: true,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ExpansionColors.darkGrey,
        contentTextStyle: GoogleFonts.kellySlab(color: ExpansionColors.white),
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.kellySlabTextTheme(base.textTheme).apply(
        bodyColor: ExpansionColors.white,
        displayColor: ExpansionColors.white,
      ),
    );
  }
}
