import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircleButton extends StatelessWidget {
  final Function() click;
  final String iconPath;
  const CircleButton({required this.iconPath, required this.click, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: click,
      child: Container(
        width: 50,
        height: 50,
        padding: const EdgeInsets.all(8),
        decoration: AppColor.buttonCircleBox,
        child: SvgPicture.asset(
          iconPath,
          colorFilter:
              const ColorFilter.mode(AppColor.darkYeloow, BlendMode.srcIn),
        ),
      ),
    );
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
          width: 2,
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
