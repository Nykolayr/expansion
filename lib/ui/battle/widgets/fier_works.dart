import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FireworkScreen extends StatefulWidget {
  final ConfettiController controllerCenter;
  const FireworkScreen({required this.controllerCenter, super.key});

  @override
  FireworkScreenState createState() => FireworkScreenState();
}

class FireworkScreenState extends State<FireworkScreen> {
  void play() {
    widget.controllerCenter.play();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);
    const numberOfPoints = 5;
    final halfWidth = size.width.w / 2;
    final externalRadius = halfWidth.r;
    final internalRadius = halfWidth / 2.5.r;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (var step = 0.0; step < fullAngle; step += degreesPerStep) {
      path
        ..lineTo(halfWidth + externalRadius * cos(step),
            halfWidth + externalRadius * sin(step))
        ..lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
            halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Align(
            child: ConfettiWidget(
              confettiController: widget.controllerCenter,
              blastDirectionality: BlastDirectionality
                  .explosive, // don't specify a direction, blast randomly
              shouldLoop:
                  true, // start again as soon as the animation is finished
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ], // manually specify the colors to be used
              createParticlePath: drawStar, // define a custom shape/path.
            ),
          ),
        ],
      ),
    );
  }
}
