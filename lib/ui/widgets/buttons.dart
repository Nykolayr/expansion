import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtonSide extends StatelessWidget {
  final bool isLeft;
  final bool isUp;
  final String title;
  const ButtonSide(this.title, {this.isLeft = true, this.isUp = true, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 120,
      child: Center(
        child: Stack(
          children: [
            SvgPicture.asset(
              isUp ? 'assets/svg/top_out.svg' : 'assets/svg/bottom_out.svg',
              // color: isUp ? AppColor.darkYeloow : AppColor.darkBlue,
              width: 200,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 5,
                top: 5,
              ),
              child: SvgPicture.asset(
                isUp ? 'assets/svg/top_in.svg' : 'assets/svg/bottom_in.svg',
                width: 185,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 30,
                top: 12,
              ),
              child: Text(
                title,
                style: AppText.baseText.copyWith(
                  color: isUp ? AppColor.darkYeloow : AppColor.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
