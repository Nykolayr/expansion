import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppText {
  static TextStyle baseText = TextStyle(
    color: AppColor.darkYeloow,
    fontWeight: FontWeight.w400,
    fontSize: 21.sp,
  );

  static TextStyle baseTextShadow = TextStyle(
    color: AppColor.darkYeloow,
    fontWeight: FontWeight.w400,
    fontSize: 21.sp,
    shadows: <Shadow>[
      Shadow(
        offset: Offset(2.w, 2.w),
        blurRadius: 10.0.r,
        color: AppColor.black,
      ),
    ],
  );
  static TextStyle baseTitle = TextStyle(
    color: AppColor.darkYeloow,
    fontWeight: FontWeight.w400,
    fontSize: 18.sp,
  );
  static TextStyle baseBody = TextStyle(
    color: AppColor.white,
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
  );

  static TextStyle baseBodyBoldYellow = TextStyle(
    color: AppColor.darkYeloow,
    fontWeight: FontWeight.w700,
    fontSize: 16.sp,
  );

  static TextStyle baseBodyBold = TextStyle(
    color: AppColor.white,
    fontWeight: FontWeight.w700,
    fontSize: 16.sp,
  );
  static TextStyle baseUrl = TextStyle(
    color: AppColor.blue,
    fontWeight: FontWeight.w400,
    fontSize: 16.sp,
  );
}
