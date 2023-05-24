import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';
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
