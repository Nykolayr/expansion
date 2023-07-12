import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget getInfo(BaseObject base) {
  int levelShild = (base.shild / base.typeStatus.minShild).round();
  int levelSpeed = (base.speedBuild / base.typeStatus.speedRoket).round() - 1;
  bool isUpShild = false;
  bool isUpSpeed = false;
  if (base.resources > 100 * (1 << (levelSpeed))) isUpSpeed = true;
  if (base.resources > 100 * (1 << (levelShild))) isUpShild = true;
  return SizedBox(
    width: base.size,
    height: base.size,
    child: Stack(
      alignment: Alignment.center,
      children: [
        if (isUpSpeed && base.typeStatus == TypeStatus.our)
          Positioned(
            top: 0,
            left: 0,
            child: GestureDetector(
              onTap: () => base.upSpeedBuild(),
              child: const UpLevel(infoStatus: InfoStatus.rocket),
            ),
          ),
        if (isUpShild && base.typeStatus == TypeStatus.our)
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => base.upShild(),
              child: const UpLevel(infoStatus: InfoStatus.shild),
            ),
          ),
        Positioned(
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 3,
              vertical: 1,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                if (base.shild > 0) const SizedBox(width: 2),
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
      width: 35,
      height: 35,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg/up.svg',
            colorFilter:
                const ColorFilter.mode(AppColor.darkYeloow, BlendMode.srcIn),
          ),
          Positioned(
            bottom: 8,
            child: SvgPicture.asset(
              infoStatus.pathImage,
              width: 12,
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
          width: 11,
          colorFilter: const ColorFilter.mode(AppColor.white, BlendMode.srcIn),
        ),
        const SizedBox(
          width: 1,
        ),
        Text(
          infoStatus.infoText(base),
          style: const TextStyle(
            color: AppColor.white,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// enum для постройки уровня щита или скорости производства ракет
/// для каждого следующего уровня необходимо больше ресурсов

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
        width: widget.size,
      ),
    );
  }
}
