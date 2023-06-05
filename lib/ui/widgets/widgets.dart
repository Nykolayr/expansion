import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget getInfo(BaseObject base) {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
    color: base.typeStatus.color,
    child: Column(
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/svg/rocket.svg',
              colorFilter:
                  ColorFilter.mode(base.typeStatus.colorText, BlendMode.srcIn),
              width: 10,
            ),
            const SizedBox(width: 2),
            Text(
              base.ships.toString(),
              style: TextStyle(
                color: base.typeStatus.colorText,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            SvgPicture.asset(
              'assets/svg/shield.svg',
              colorFilter:
                  ColorFilter.mode(base.typeStatus.colorText, BlendMode.srcIn),
              width: 10,
            ),
            const SizedBox(width: 2),
            Text(
              base.shild.toStringAsFixed(0),
              style: TextStyle(
                color: base.typeStatus.colorText,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Row(
          children: [
            SvgPicture.asset(
              'assets/svg/hammers.svg',
              colorFilter:
                  ColorFilter.mode(base.typeStatus.colorText, BlendMode.srcIn),
              width: 10,
            ),
            const SizedBox(width: 2),
            Text(
              base.resources.toStringAsFixed(0),
              style: TextStyle(
                color: base.typeStatus.colorText,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    ),
  );
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
