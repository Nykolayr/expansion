import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/text.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget getInfo(BaseObject base) {
  bool isUpShild = getIsUpShild(base);
  bool isUpSpeed = getIsUpSpeed(base);
  return SizedBox(
    width: base.size.w,
    height: base.size.h,
    child: Stack(
      alignment: Alignment.center,
      children: [
        if (isUpSpeed && base.typeStatus == TypeStatus.our)
          Positioned(
            top: 0.h,
            left: 0.w,
            child: GestureDetector(
              onTap: () => base.upSpeedBuild(),
              child: const UpLevel(infoStatus: InfoStatus.rocket),
            ),
          ),
        if (isUpShild && base.typeStatus == TypeStatus.our)
          Positioned(
            top: 0.h,
            right: 0.w,
            child: GestureDetector(
              onTap: () => base.upShild(),
              child: const UpLevel(infoStatus: InfoStatus.shild),
            ),
          ),
        Positioned(
          bottom: 0.h,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 3,
              vertical: 1,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(const Radius.circular(10).r),
              color: (base.typeStatus == TypeStatus.neutral)
                  ? Colors.blue.withOpacity(0.9)
                  : base.typeStatus.color.withOpacity(0.9),
            ),
            child: Row(
              children: [
                CircleInfo(
                  base: base,
                  infoStatus: InfoStatus.rocket,
                ),
                if (base.shild > 0) SizedBox(width: 2.w),
                if (base.shild > 0)
                  CircleInfo(
                    base: base,
                    infoStatus: InfoStatus.shild,
                  ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class UpLevel extends StatelessWidget {
  final InfoStatus infoStatus;
  const UpLevel({required this.infoStatus, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35.w,
      height: 35.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg/up.svg',
            colorFilter:
                const ColorFilter.mode(AppColor.darkYeloow, BlendMode.srcIn),
          ),
          Positioned(
            bottom: 8.h,
            child: SvgPicture.asset(
              infoStatus.pathImage,
              width: 12.w,
              colorFilter:
                  const ColorFilter.mode(AppColor.black, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }
}

class CircleInfo extends StatelessWidget {
  final InfoStatus infoStatus;
  final BaseObject base;
  const CircleInfo({required this.base, required this.infoStatus, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          infoStatus.pathImage,
          width: 11.w,
          colorFilter: const ColorFilter.mode(AppColor.white, BlendMode.srcIn),
        ),
        SizedBox(
          width: 1.w,
        ),
        Text(
          infoStatus.infoText(base),
          style: TextStyle(
            color: AppColor.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

Widget titleWithSvg(String text) {
  return Stack(
    alignment: Alignment.center,
    children: [
      SvgPicture.asset(
        'assets/svg/titul.svg',
        width: deviceSize.width,
        height: 40,
        fit: BoxFit.fitWidth,
      ),
      Text(
        text,
        style: TextStyle(
          color: AppColor.darkYeloow,
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

/// проверяет, хватает ли ресурсов на следующий ап щита базы
bool getIsUpShild(BaseObject base) {
  if (base.typeStatus == TypeStatus.neutral ||
      base.typeStatus == TypeStatus.asteroid) return false;
  int levelShild = (base.shild / base.typeStatus.minShild).round();
  bool isUpShild = false;

  if (base.resources > 100 * (1 << (levelShild))) isUpShild = true;
  return isUpShild;
}

/// проверяет, хватает ли ресурсов на следующий ап ускорения постройки кораблей базы
bool getIsUpSpeed(BaseObject base) {
  if (base.typeStatus == TypeStatus.neutral ||
      base.typeStatus == TypeStatus.asteroid) return false;
  int levelSpeed =
      (base.speedBuild / base.typeStatus.speedBuildShip).round() - 1;
  bool isUpSpeed = false;
  if (base.resources > 100 * (1 << (levelSpeed))) isUpSpeed = true;
  return isUpSpeed;
}

/// enum для вывода информации о количестве ракет и щита
enum InfoStatus {
  shild,
  rocket,
  resources;

  String get pathImage {
    switch (this) {
      case InfoStatus.shild:
        return 'assets/svg/shield.svg';
      case InfoStatus.rocket:
        return 'assets/svg/rocket.svg';
      case InfoStatus.resources:
        return 'assets/svg/hammers.svg';
    }
  }

  String infoText(BaseObject base) {
    switch (this) {
      case InfoStatus.shild:
        return base.shild.toStringAsFixed(0);
      case InfoStatus.rocket:
        return base.ships.toString();
      case InfoStatus.resources:
        return base.resources.toStringAsFixed(0);
    }
  }
}

/// вращающаяся икона битвы, когда отряд кораблей нападет на станцию
class IconRotate extends StatefulWidget {
  final double size;
  const IconRotate({super.key, required this.size});

  @override
  State<IconRotate> createState() => IconRotateState();
}

class IconRotateState extends State<IconRotate> {
  double turns = 0.0;
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 200), () {
      _changeRotation();
    });
    super.initState();
  }

  void _changeRotation() {
    if (!mounted) return;
    setState(() => turns = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: turns,
      duration: const Duration(milliseconds: 1500),
      child: SvgPicture.asset(
        'assets/svg/battle.svg',
        width: widget.size.w,
      ),
    );
  }
}

/// вызывает SnackBar, без дублирования
class SnackBarHelper {
  static bool isShowingSnackBar = false;

  static void showUpgradeSnackBar(BuildContext context, String text) {
    if (isShowingSnackBar) {
      return; // Do nothing if a SnackBar is already being shown
    }

    isShowingSnackBar = true;

    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            backgroundColor: AppColor.darkBlue,
            content: Text(
              text,
              style: AppText.baseText.copyWith(
                fontSize: 16.sp,
                color: AppColor.darkYeloow,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
        .closed
        .then((_) {
      // SnackBar closed callback
      isShowingSnackBar = false;
    });
  }
}
