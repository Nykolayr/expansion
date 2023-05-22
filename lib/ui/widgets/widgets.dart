import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
