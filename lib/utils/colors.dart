import 'package:flutter/material.dart';

class AppColor {
  static const Color darkYeloow = Color(0xFFFABE0D);
  static const Color darkBlue = Color(0xFF0D2D54);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF0C0D0D);
  static const Color darkGrey = Color(0xFF3C4345);
  static const Color red = Color(0xFFA42208);
  static const Color blue = Color(0xFF6CCFF9);
  static const Color green = Color(0xFF40DE8F);
  static const Color grey = Color(0xFFBAB6B6);
  static const Color darkGreen = Color(0xFF02874D);

  static const BoxDecoration ourPlanet = BoxDecoration(
    gradient: RadialGradient(
      colors: [white, darkGreen],
      radius: 0.5,
      focal: Alignment(0.7, -0.7),
      tileMode: TileMode.clamp,
    ),
    shape: BoxShape.circle,
  );
  static const BoxDecoration neutralPlanet = BoxDecoration(
    gradient: RadialGradient(
      colors: [grey, black],
      radius: 0.75,
      focal: Alignment(0.7, -0.7),
      tileMode: TileMode.clamp,
    ),
    shape: BoxShape.circle,
  );

  static const BoxDecoration enemyPlanet = BoxDecoration(
    gradient: RadialGradient(
      colors: [white, red],
      radius: 0.5,
      focal: Alignment(0.7, -0.7),
      tileMode: TileMode.clamp,
    ),
    shape: BoxShape.circle,
  );

  static const BoxDecoration agressivePlanet = BoxDecoration(
    gradient: RadialGradient(
      colors: [red, grey],
      radius: 0.75,
      focal: Alignment(0.7, -0.7),
      tileMode: TileMode.clamp,
    ),
    shape: BoxShape.circle,
  );

  static const BoxDecoration sun = BoxDecoration(
    gradient: RadialGradient(
      colors: [Colors.redAccent, Colors.yellow],
      radius: 0.75,
      focal: Alignment(0.7, -0.7),
      tileMode: TileMode.clamp,
    ),
    shape: BoxShape.circle,
  );
}
