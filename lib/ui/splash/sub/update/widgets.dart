import 'package:expansion/domain/models/upgrade.dart';
import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// функция вывода строки для улучшения
Widget upgradeAdding(Upgrade upgrade) {
  TypeUp type = upgrade.type;
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 20.h),
    child: Row(
      children: [
        // CircleButton(
        //   iconPath: 'assets/svg/help.svg',
        //   click: () {},
        //   style: CircleButtonStyle.small,
        // ),
        // SizedBox(width: 15.w),
        Text(
          type.text,
          style: TextStyle(
            color: AppColor.darkYeloow,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
