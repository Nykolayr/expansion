import "package:easy_localization/easy_localization.dart";
import "package:expansion/routers/routers.dart";
import "package:expansion/utils/colors.dart";
import "package:expansion/utils/text.dart";
import "package:expansion/utils/value.dart";
import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import "package:flutter_svg/svg.dart";

class ButtonSide extends StatelessWidget {
  final Direct direct;
  final String? title;
  final Function()? function;
  const ButtonSide(this.direct, {this.function, this.title, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widht = deviceSize.width / 3;
    double height = widht / 3.h;
    String text = title ?? direct.title;
    Function()? fun = function ?? () => router.go(direct.router);
    return GestureDetector(
      onTap: fun,
      child: SizedBox(
        width: widht.w,
        height: height.h,
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
                  left: direct.paddingText.w,
                  right: direct.isLeft ? 8.w : 0.w,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    text,
                    style: AppText.baseText.copyWith(
                      fontSize: 15.sp,
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

class ButtonLong extends StatelessWidget {
  final String title;
  final Function() function;
  final bool isWidth;
  const ButtonLong(
      {required this.function,
      required this.title,
      this.isWidth = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double widht = deviceSize.width - 90.h;
    if (isWidth) {
      widht = widht + 60.w;
    }
    return GestureDetector(
      onTap: function,
      child: SizedBox(
        width: widht,
        child: Center(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  "assets/svg/bottom_long.svg",
                  width: widht,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                width: widht,
                padding: EdgeInsets.only(
                  top: isWidth ? 0 : 10.h,
                  right: isWidth ? 0 : 8.w,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: AppText.baseText.copyWith(
                      fontSize: isWidth ? 20.sp : 16.sp,
                      color: AppColor.darkYeloow,
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
        return "assets/svg/bottom_in.svg";
      case Direct.rightBottom:
        return "assets/svg/bottom_right_in.svg";
      case Direct.leftTop:
        return "assets/svg/top_in.svg";
      case Direct.rightTop:
        return "assets/svg/top_right_in.svg";
      case Direct.meddleBottom:
        return "assets/svg/bottom_middle_in.svg";
      case Direct.meddleTop:
        return "assets/svg/top_middle_in.svg";
      default:
        return "";
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

  String get router {
    switch (this) {
      case Direct.leftBottom:
        return "/new_game";
      case Direct.rightBottom:
        return "/battle";
      case Direct.leftTop:
        return "/profile";
      case Direct.rightTop:
        return "/progress";
      case Direct.meddleBottom:
        return "/update";
      case Direct.meddleTop:
        return "/settings";
      default:
        return "/settings";
    }
  }

  String get title {
    switch (this) {
      case Direct.leftBottom:
        return tr("new_game");
      case Direct.rightBottom:
        return tr("сontinue");
      case Direct.leftTop:
        return tr("profile");
      case Direct.rightTop:
        return tr("progress");
      case Direct.meddleBottom:
        return tr("upgrades");
      case Direct.meddleTop:
        return tr("settings");
      default:
        return "";
    }
  }
}
