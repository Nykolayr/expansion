import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;

class ButtonSide extends StatelessWidget {
  final Direct direct;
  final String title;
  const ButtonSide(this.direct, {this.title = '', Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widht = MediaQuery.of(context).size.width / 3;
    double height = widht / 4;
    String text = title;
    if (text.isEmpty) text = direct.title;
    return GestureDetector(
      onTap: direct.pressButton,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(direct.isLeft ? 0 : math.pi),
        child: SizedBox(
          width: widht,
          height: height,
          child: Center(
            child: Stack(
              children: [
                SvgPicture.asset(
                  direct.puthOut,
                  width: widht,
                  height: height,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: direct.paddingLeft / 2,
                    vertical: 7,
                  ),
                  child: SvgPicture.asset(
                    direct.puthIn,
                    width: widht - 20,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(direct.isLeft ? 0 : math.pi),
                  child: Container(
                    width: widht - 20,
                    padding: EdgeInsets.only(
                      left: direct.paddingText,
                      top: 8,
                    ),
                    child: Text(
                      text,
                      style: AppText.baseText.copyWith(
                        fontSize: 15,
                        color: direct.colorText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum Direct {
  leftTop,
  leftBottom,
  meddleTop,
  meddleBottom,
  rightTop,
  rightBottom,
}

extension DirectExtention on Direct {
  Color get colorText {
    switch (this) {
      case Direct.leftBottom:
      case Direct.rightBottom:
      case Direct.meddleTop:
        return AppColor.black;
      default:
        return AppColor.darkYeloow;
    }
  }

  String get puthIn {
    switch (this) {
      case Direct.leftBottom:
      case Direct.rightBottom:
        return 'assets/svg/bottom_in.svg';
      case Direct.leftTop:
      case Direct.rightTop:
        return 'assets/svg/top_in.svg';
      case Direct.meddleBottom:
        return 'assets/svg/bottom_middle_in.svg';
      case Direct.meddleTop:
        return 'assets/svg/top_middle_in.svg';
      default:
        return '';
    }
  }

  double get paddingLeft {
    switch (this) {
      case Direct.leftBottom:
      case Direct.leftTop:
      case Direct.rightTop:
      case Direct.rightBottom:
        return 12;
      default:
        return 24;
    }
  }

  double get paddingText {
    switch (this) {
      case Direct.leftBottom:
      case Direct.leftTop:
      case Direct.rightTop:
      case Direct.rightBottom:
        return 14;
      default:
        return 8;
    }
  }

  String get puthOut {
    switch (this) {
      case Direct.leftBottom:
      case Direct.rightBottom:
        return 'assets/svg/bottom_out.svg';
      case Direct.leftTop:
      case Direct.rightTop:
        return 'assets/svg/top_out.svg';
      case Direct.meddleBottom:
        return 'assets/svg/bottom_middle_out.svg';
      case Direct.meddleTop:
        return 'assets/svg/top_middle_out.svg';
      default:
        return '';
    }
  }

  bool get isLeft {
    switch (this) {
      case Direct.leftBottom:
      case Direct.leftTop:
        return true;
      default:
        return false;
    }
  }

  Function() get pressButton {
    switch (this) {
      case Direct.leftBottom:
        return () {
          print('object == $name');
        };
      case Direct.rightBottom:
        return () {
          print('object == $name');
        };
      case Direct.leftTop:
        return () {
          print('object == $name');
        };
      case Direct.rightTop:
        return () {
          print('object == $name');
        };
      case Direct.meddleBottom:
        return () {
          print('object == $name');
        };
      case Direct.meddleTop:
        return () {
          print('object == $name');
        };
      default:
        return () {
          print('object == default');
        };
    }
  }

  String get title {
    switch (this) {
      case Direct.leftBottom:
        return tr('new_game');
      case Direct.rightBottom:
        return tr('сontinue');
      case Direct.leftTop:
        return tr('profile');
      case Direct.rightTop:
        return tr('progress');
      case Direct.meddleBottom:
        return tr('upgrades');
      case Direct.meddleTop:
        return tr('settings');
      default:
        return '';
    }
  }
}
