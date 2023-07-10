import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';

class AppText {
  static const TextStyle baseText = TextStyle(
    color: AppColor.darkYeloow,
    fontWeight: FontWeight.w400,
    fontSize: 21,
  );

  static const TextStyle baseTextShadow = TextStyle(
    color: AppColor.darkYeloow,
    fontWeight: FontWeight.w400,
    fontSize: 21,
    shadows: <Shadow>[
      Shadow(
        offset: Offset(2, 2),
        blurRadius: 10.0,
        color: AppColor.black,
      ),
    ],
  );
  static const TextStyle baseTitle = TextStyle(
    color: AppColor.darkYeloow,
    fontWeight: FontWeight.w400,
    fontSize: 18,
  );
  static const TextStyle baseBody = TextStyle(
    color: AppColor.white,
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );
  static const TextStyle baseUrl = TextStyle(
    color: AppColor.blue,
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );
}
