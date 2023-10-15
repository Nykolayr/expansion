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

  static BoxDecoration ourPlanet = BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        width: 2,
        color: darkGreen,
      ));

  static BoxDecoration neutralPlanet = BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        width: 2,
        color: white,
      ));

  static BoxDecoration enemyPlanet = BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        width: 2,
        color: red,
      ));

  static BoxDecoration shildBox = BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        width: 2,
        color: blue,
      ));
  static BoxDecoration notShildBox = BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        width: 2,
        color: Colors.transparent,
      ));
  static BoxDecoration buttonCircleBox = const BoxDecoration(
    color: AppColor.darkBlue,
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: Colors.yellow,
        spreadRadius: 3,
        blurRadius: 3,
      ),
    ],
  );
  static BoxDecoration buttonCircleBoxSmall = const BoxDecoration(
    color: AppColor.darkBlue,
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: Colors.yellow,
        spreadRadius: 1.5,
        blurRadius: 1.5,
      ),
    ],
  );
}
