import 'package:expansion/ui/widgets/buttons.dart';
import 'package:flutter/material.dart';

class LineButtons extends StatelessWidget {
  final bool isTop;
  final bool isBegin;
  const LineButtons({this.isTop = true, this.isBegin = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widht = MediaQuery.of(context).size.width / 3;
    double height = widht / 4;
    return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 30,
        ),
        height: height,
        width: double.infinity,
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
                    alignment: Alignment.center,
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
                    alignment: Alignment.center,
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
