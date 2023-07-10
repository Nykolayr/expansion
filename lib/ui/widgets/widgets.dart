import 'package:expansion/domain/models/entities/base.dart';
import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget getInfo(BaseObject base) {
  return SizedBox(
    width: base.size,
    height: base.size,
    child: Stack(
      alignment: Alignment.center,
      children: [
        if (base.typeStatus != TypeStatus.neutral)
          Positioned(
            top: (base is Base) ? 1 : 7,
            child: CircleInfo(
              base: base,
              infoStatus: InfoStatus.resources,
            ),
          ),
        Positioned(
          bottom: 0,
          left: 0,
          child: CircleInfo(
            base: base,
            infoStatus: InfoStatus.rocket,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: CircleInfo(
            base: base,
            infoStatus: InfoStatus.shild,
          ),
        ),
      ],
    ),
  );
}

class CircleInfo extends StatelessWidget {
  final InfoStatus infoStatus;
  final BaseObject base;
  const CircleInfo({required this.base, required this.infoStatus, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 2.5,
        vertical: 1,
      ),
      width: 32,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: (base.typeStatus == TypeStatus.neutral)
            ? Colors.blue.withOpacity(0.6)
            : base.typeStatus.color.withOpacity(0.6),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              infoStatus.pathImage,
              width: 11,
              colorFilter:
                  const ColorFilter.mode(AppColor.white, BlendMode.srcIn),
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
        ),
      ),
    );
  }
}

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
    Future.delayed(const Duration(milliseconds: 100), () {
      _changeRotation();
    });
    super.initState();
  }

  void _changeRotation() {
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
