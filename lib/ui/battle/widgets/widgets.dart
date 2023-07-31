import 'package:expansion/routers/routers.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget appButtonBack(String title) {
  return Positioned(
    top: 20.h,
    left: 20.w,
    child: SizedBox(
      width: deviceSize.width - 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleButton(
            iconPath: 'assets/svg/back.svg',
            click: () => router.pop(),
            style: CircleButtonStyle.small,
          ),
          Text(
            title,
            style: AppText.baseText.copyWith(
              fontSize: 30.sp,
            ),
          ),
          SizedBox(width: 30.w),
        ],
      ),
    ),
  );
}

class CircleButton extends StatelessWidget {
  final Function() click;
  final String iconPath;
  final CircleButtonStyle style;
  const CircleButton(
      {required this.iconPath,
      required this.click,
      super.key,
      this.style = CircleButtonStyle.medium});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: click,
      child: Container(
        width: style.radius.r,
        height: style.radius.r,
        padding: EdgeInsets.all(8.r),
        decoration: style.shadow,
        child: SvgPicture.asset(
          iconPath,
          colorFilter:
              const ColorFilter.mode(AppColor.darkYeloow, BlendMode.srcIn),
        ),
      ),
    );
  }
}

enum CircleButtonStyle {
  small,
  medium;

  double get radius {
    switch (this) {
      case CircleButtonStyle.small:
        return 30;
      case CircleButtonStyle.medium:
        return 50;
    }
  }

  BoxDecoration get shadow {
    switch (this) {
      case CircleButtonStyle.small:
        return AppColor.buttonCircleBoxSmall;
      case CircleButtonStyle.medium:
        return AppColor.buttonCircleBox;
    }
  }
}

class CheckBox extends StatelessWidget {
  final bool isCheck;
  const CheckBox({required this.isCheck, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25.w,
      height: 25.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColor.darkYeloow,
          width: 2.w,
        ),
        color: AppColor.darkBlue,
      ),
      child: isCheck
          ? SvgPicture.asset(
              'assets/svg/check.svg',
              width: 20.w,
              colorFilter:
                  const ColorFilter.mode(AppColor.darkYeloow, BlendMode.srcIn),
            )
          : const SizedBox.shrink(),
    );
  }
}
