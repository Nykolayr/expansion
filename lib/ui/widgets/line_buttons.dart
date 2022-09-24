import 'package:expansion/ui/widgets/buttons.dart';
import 'package:flutter/material.dart';

class LineButtons extends StatelessWidget {
  final bool isTop;
  final bool isBegin;
  const LineButtons({this.isTop = true, this.isBegin = false, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double widht = MediaQuery.of(context).size.width / 3 - 6;
    final double height = widht / 3 + 10;
    return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 20,
        ),
        height: height,
        width: MediaQuery.of(context).size.width - 30,
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

class LineMenu extends StatelessWidget {
  final String title1;
  final String title2;
  final Function() click;

  const LineMenu(this.title1, this.title2, this.click, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double widht = (MediaQuery.of(context).size.width - 45) / 2 - 12;
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
