import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:expansion/ui/maps/widgets.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;
import 'package:get/get.dart';
import 'package:surf_logger/surf_logger.dart';

class Scene {
  int id = 0;
  String nameRu = '';
  String nameEn = '';
  String battleRu = '';
  String battleEn = '';
  String descriptionRu = '';
  String descriptionEn = '';
  TypeScene typeScene = TypeScene.first;
  Scene({
    required this.id,
    required this.nameRu,
    required this.nameEn,
    required this.battleRu,
    required this.battleEn,
    required this.descriptionRu,
    required this.descriptionEn,
    required this.typeScene,
  });
  factory Scene.fromJson(Map<String, dynamic> json) {
    return Scene(
      id: json['id'] as int? ?? 0,
      nameRu: json['nameRu'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      battleRu: json['battleRu'] as String? ?? '',
      battleEn: json['battleEn'] as String? ?? '',
      descriptionRu: json['descriptionRu'] as String? ?? '',
      descriptionEn: json['descriptionEn'] as String? ?? '',
      typeScene: json['typeScene'] == null
          ? TypeScene.first
          : TypeScene.values.byName(json['typeScene'] as String),
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'nameRu': nameRu,
        'nameEn': nameEn,
        'battleRu': battleRu,
        'battleEn': battleEn,
        'descriptionRu': descriptionRu,
        'descriptionEn': descriptionEn,
        'typeScene': typeScene.name,
      };
  Widget build({
    required int index,
    required BuildContext context,
  }) {
    final current = Get.find<UserRepository>().user.mapClassic - 1;
    final infoText = context.locale == const Locale('ru') ? nameEn : nameRu;
    Widget info =
        Text((id + 1).toString(), style: AppText.baseBodyBoldYellow18);
    if (current == id) {
      Logger.d(' current >>>>>>>>>>>>>>>>>>>>== $current');
      info = SvgPicture.asset('assets/svg/target.svg', width: 25.w);
    }
    if (current < id) {
      info = SvgPicture.asset('assets/svg/lock.svg',
          colorFilter:
              const ColorFilter.mode(AppColor.darkYeloow, BlendMode.srcIn),
          width: 15.w);
    }
    final isOddLine = (index ~/ 5).isEven;
    return GestureDetector(
      child: Opacity(
        opacity: id > current + 3 ? 0.4 : 1,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: typeScene.padding),
                  alignment: Alignment.center,
                  height: 55.w,
                  padding: EdgeInsets.only(bottom: 25.h),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: svg.Svg('assets/svg/scene.svg'))),
                  child: info,
                ),
                Text(
                  current + 1 > index ? infoText : '???????',
                  style: AppText.baseBodyBold12,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            // if ((isOddLine && typeScene == TypeScene.fifth) ||
            //     (!isOddLine && typeScene == TypeScene.first))
            if (!isOddLine) CustomPaint(painter: typeScene.lineEven),
            if (isOddLine) CustomPaint(painter: typeScene.lineOdd),
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

  LinePainter get lineEven {
    switch (this) {
      case TypeScene.first:
        return LinePainter(begin: Offset(40.w, 40.h), end: Offset(40.w, 160.h));
      case TypeScene.second:
      case TypeScene.fourth:
        return LinePainter(begin: Offset(40.w, 75.h), end: Offset(-40.w, 40.h));
      case TypeScene.third:
        return LinePainter(begin: Offset(40.w, 40.h), end: Offset(-40.w, 75.h));
      case TypeScene.fifth:
        return LinePainter(
            begin: Offset(40.w, 40.h), end: Offset(40.w, -120.h));
    }
  }

  LinePainter get lineOdd {
    switch (this) {
      case TypeScene.first:
        return LinePainter(begin: Offset.zero, end: Offset.zero);
      case TypeScene.second:
      case TypeScene.fourth:
        return LinePainter(begin: Offset(40.w, 75.h), end: Offset(-40.w, 40.h));
      case TypeScene.third:
      case TypeScene.fifth:
        return LinePainter(begin: Offset(40.w, 40.h), end: Offset(-40.w, 75.h));
    }
  }
}
