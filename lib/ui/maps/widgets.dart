import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/domain/models/maps/scenes.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;
import 'package:get/get.dart';

class SceneView extends StatelessWidget {
  final int index;
  final Scene scene;
  const SceneView({required this.index, required this.scene, super.key});

  @override
  Widget build(BuildContext context) {
    final current = Get.find<UserRepository>().user.mapClassic - 1;
    final infoText =
        context.locale == const Locale('ru') ? scene.nameEn : scene.nameRu;
    Widget info =
        Text((scene.id + 1).toString(), style: AppText.baseBodyBoldYellow18);
    if (current == scene.id) {
      info = SvgPicture.asset('assets/svg/target.svg', width: 25.w);
    }
    if (current < scene.id) {
      info = SvgPicture.asset('assets/svg/lock.svg',
          colorFilter:
              const ColorFilter.mode(AppColor.darkYeloow, BlendMode.srcIn),
          width: 15.w);
    }
    final isOddLine = (index ~/ 5).isEven;
    return GestureDetector(
      child: Opacity(
        opacity: scene.id > current + 3 ? 0.4 : 1,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: scene.typeScene.padding),
                  alignment: Alignment.center,
                  height: 55.w,
                  padding: EdgeInsets.only(bottom: 25.h),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: svg.Svg('assets/svg/scene.svg'))),
                  child: info,
                ),
                Text(
                  current + 1 > scene.id ? infoText : '???????',
                  style: AppText.baseBodyBold12,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            if (!isOddLine && scene.id != 100 && scene.id != 99)
              CustomPaint(
                  painter: LinePainter(
                      begin: scene.typeScene.flyEven.begin,
                      end: scene.typeScene.flyEven.end)),
            if (isOddLine && scene.id != 100 && scene.id != 99)
              CustomPaint(
                  painter: LinePainter(
                      begin: scene.typeScene.flyOdd.begin,
                      end: scene.typeScene.flyOdd.end)),
          ],
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final Offset begin;
  final Offset end;

  LinePainter({
    required this.begin,
    required this.end,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColor.red
      ..strokeWidth = 3;

    canvas.drawLine(Offset(begin.dx, begin.dy), Offset(end.dx, end.dy), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

/// функция загрузки картинки из assets для canvas
Future<ui.Image> loadImage(String asset) async {
  final data = await rootBundle.load(asset);
  final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
  final fi = await codec.getNextFrame();
  return fi.image;
}
