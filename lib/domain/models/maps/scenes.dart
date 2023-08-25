import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:expansion/ui/maps/widgets.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;

class Scene {
  String nameRu = '';
  String nameEn = '';
  TypeScene typeScene = TypeScene.first;
  Scene({
    required this.nameRu,
    required this.nameEn,
    required this.typeScene,
  });
  factory Scene.fromJson(Map<String, dynamic> json) {
    return Scene(
      nameRu: json['nameRu'],
      nameEn: json['nameEn'],
      typeScene: json['typeScene'] == null
          ? TypeScene.first
          : TypeScene.values.byName(json['typeScene']),
    );
  }
  Map<String, dynamic> toJson() => {
        "nameRu": nameRu,
        "nameEn": nameEn,
        "typeScene": typeScene.name,
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
    bool isOddLine = (index ~/ 5).isEven;
    return GestureDetector(
      child: Opacity(
        opacity: index > current + 3 ? 0.4 : 1,
        child: Stack(
          children: [
            CustomPaint(
              painter: LinePainter(
                  begin: typeScene.leftBegin, end: typeScene.leftEnd),
            ),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: typeScene.padding),
                  alignment: Alignment.center,
                  height: 55.w,
                  padding: EdgeInsets.only(bottom: 25.h),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: svg.Svg("assets/svg/scene.svg"))),
                  child: info,
                ),
                Text(
                  current + 1 > index ? infoText : '???????',
                  style: AppText.baseBodyBold12,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            if ((isOddLine && typeScene == TypeScene.fifth) ||
                (!isOddLine && typeScene == TypeScene.first))
              CustomPaint(
                painter: LinePainter(
                    begin: typeScene.rightBegin, end: typeScene.rightEnd),
              ),
          ],
        ),
      ),
    );
  }
}

enum TypeScene {
  first,
  second,
  third,
  fourth,
  fifth;

  double get padding {
    switch (this) {
      case TypeScene.first:
      case TypeScene.third:
      case TypeScene.fifth:
        return 0;
      case TypeScene.second:
      case TypeScene.fourth:
        return 35.w;
    }
  }

  Offset get leftBegin {
    switch (this) {
      case TypeScene.first:
        return const Offset(0, 0);
      case TypeScene.second:
      case TypeScene.fourth:
        return Offset(-20.w, 40.h);
      case TypeScene.third:
      case TypeScene.fifth:
        return Offset(-20.w, 75.h);
    }
  }

  Offset get leftEnd {
    switch (this) {
      case TypeScene.first:
        return const Offset(0, 0);
      case TypeScene.second:
      case TypeScene.fourth:
        return Offset(18.w, 75.h);
      case TypeScene.third:
      case TypeScene.fifth:
        return Offset(18.w, 40.h);
    }
  }

  Offset get rightBegin {
    switch (this) {
      case TypeScene.second:
      case TypeScene.third:
      case TypeScene.fourth:
        return const Offset(0, 0);
      case TypeScene.first:
      case TypeScene.fifth:
        return Offset(40.w, 50.h);
    }
  }

  Offset get rightEnd {
    switch (this) {
      case TypeScene.second:
      case TypeScene.third:
      case TypeScene.fourth:
        return const Offset(0, 0);
      case TypeScene.first:
      case TypeScene.fifth:
        return Offset(40.w, 120.h);
    }
  }
}
