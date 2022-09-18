import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtonSide extends StatelessWidget {
  final Direct direct;
  final String title;
  const ButtonSide(this.direct, {this.title = '', Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widht = MediaQuery.of(context).size.width / 3;
    double height = widht / 3 ;
    String text = title;
    if (text.isEmpty) text = direct.title;
    return GestureDetector(
      onTap: direct.pressButton,
      child: SizedBox(
        width: widht,
        height: height,
        child: Center(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  direct.puthIn,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                width: widht,
                height: height,
                padding: EdgeInsets.only(
                  left: direct.paddingText,
                  right: direct.isLeft ? 8 : 0,
                ),
                child: Align(
                  alignment: Alignment.center,
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
        return 'assets/svg/bottom_in.svg';
      case Direct.rightBottom:
        return 'assets/svg/bottom_right_in.svg';
      case Direct.leftTop:
        return 'assets/svg/top_in.svg';
      case Direct.rightTop:
        return 'assets/svg/top_right_in.svg';
      case Direct.meddleBottom:
        return 'assets/svg/bottom_middle_in.svg';
      case Direct.meddleTop:
        return 'assets/svg/top_middle_in.svg';
      default:
        return '';
    }
  }

  double get paddingText {
    switch (this) {
      case Direct.leftBottom:
      case Direct.leftTop:
        return 2;
      case Direct.rightTop:
      case Direct.rightBottom:
        return 4;
      default:
        return 0;
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
