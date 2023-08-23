import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class Scene {
  double x = 0;
  double y = 0;
  String nameRu = '';
  String nameEn = '';

  Scene({
    required this.x,
    required this.y,
    required this.nameRu,
    required this.nameEn,
  });
  factory Scene.fromJson(Map<String, dynamic> json) {
    return Scene(
      x: json['x'],
      y: json['y'],
      nameRu: json['nameRu'],
      nameEn: json['nameEn'],
    );
  }
  Map<String, dynamic> toJson() => {
        "nameRu": nameRu,
        "nameEn": nameEn,
        "x": x,
        "y": y,
      };
  Widget build({
    required int index,
    required BuildContext context,
  }) {
    int current = Get.find<UserRepository>().user.mapClassic - 1;
    String infoText = context.locale == const Locale('ru') ? nameEn : nameRu;
    Widget info =
        Text((index + 1).toString(), style: AppText.baseBodyBoldYellow18);
    if (current == index) {
      info = SvgPicture.asset('assets/svg/target.svg', width: 25.w);
    }
    if (current < index) {
      info = SvgPicture.asset('assets/svg/lock.svg',
          colorFilter:
              const ColorFilter.mode(AppColor.darkYeloow, BlendMode.srcIn),
          width: 15.w);
    }
    return Positioned(
      top: y,
      left: x,
      child: GestureDetector(
        child: Opacity(
          opacity: index > current + 3 ? 0.4 : 1,
          child: SizedBox(
            width: 75.w,
            height: 80.h,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset('assets/svg/scene.svg', height: 60.w),
                    Padding(
                      padding: EdgeInsets.only(bottom: 25.h),
                      child: info,
                    ),
                  ],
                ),
                Text(
                  current + 1 > index ? infoText : '???????',
                  style: AppText.baseBodyBold12,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
