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
      inputDecorationTheme: _menuInputDecorationTheme(),
    );

    return base.copyWith(
      textTheme: GoogleFonts.kellySlabTextTheme(base.textTheme).apply(
        bodyColor: ExpansionColors.white,
        displayColor: ExpansionColors.white,
      ),
    );
  }

  static InputDecorationTheme _menuInputDecorationTheme() {
    const borderRadius = BorderRadius.all(Radius.circular(10));
    final idleBorder = BorderSide(
      color: ExpansionColors.accent.withValues(alpha: 0.35),
    );
    const focusedBorder = BorderSide(
      color: ExpansionColors.accent,
      width: 1.5,
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: ExpansionColors.background.withValues(alpha: 0.88),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: borderRadius, borderSide: idleBorder),
      enabledBorder:
          OutlineInputBorder(borderRadius: borderRadius, borderSide: idleBorder),
      focusedBorder:
          OutlineInputBorder(borderRadius: borderRadius, borderSide: focusedBorder),
      errorBorder: const OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: ExpansionColors.red),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: ExpansionColors.red, width: 1.5),
      ),
      labelStyle: GoogleFonts.kellySlab(color: ExpansionColors.white),
      hintStyle: GoogleFonts.kellySlab(color: ExpansionColors.grey),
      helperStyle: GoogleFonts.kellySlab(
        color: ExpansionColors.grey,
        fontSize: 12,
      ),
      floatingLabelStyle: GoogleFonts.kellySlab(color: ExpansionColors.accent),
    );
  }
}
