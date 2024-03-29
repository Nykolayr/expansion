import 'package:expansion/ui/widgets/buttons.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LineButtons extends StatelessWidget {
  final bool isTop;
  final bool isBegin;
  const LineButtons({this.isTop = true, this.isBegin = false, super.key});

  @override
  Widget build(BuildContext context) {
    final widht = deviceSize.width / 3;
    final height = widht / 3;
    return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        height: height,
        width: deviceSize.width.w,
        child: Stack(
          children: isTop
              ? [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: ButtonSide(
                      Direct.leftTop,
                    ),
                  ),
                  const Align(
                    child: ButtonSide(
                      Direct.meddleTop,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: ButtonSide(
                      Direct.rightTop,
                    ),
                  ),
                ]
              : [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: ButtonSide(
                      Direct.leftBottom,
                    ),
                  ),
                  const Align(
                    child: ButtonSide(
                      Direct.meddleBottom,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: ButtonSide(
                      Direct.rightBottom,
                    ),
                  ),
                ],
        ));
  }
}

class LineMenu extends StatelessWidget {
  final String title1;
  final String title2;
  final Function() click;

  const LineMenu(this.title1, this.title2, this.click, {super.key});

  @override
  Widget build(BuildContext context) {
    final widht = (deviceSize.width - 45) / 2 - 12;
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: widht,
            child: FittedBox(
              fit: BoxFit.fill,
              child: ButtonSide(
                Direct.leftTop,
                function: () {},
                title: title1,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: widht,
            child: FittedBox(
              fit: BoxFit.fill,
              child: ButtonSide(
                Direct.rightBottom,
                function: click,
                title: title2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
