import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

/// Фейерверк при победе (legacy `FireworkScreen`).
class BattleVictoryFireworks extends StatelessWidget {
  const BattleVictoryFireworks({
    required this.controller,
    super.key,
  });

  final ConfettiController controller;

  Path _starPath(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);
    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (var step = 0.0; step < fullAngle; step += degreesPerStep) {
      path
        ..lineTo(
          halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step),
        )
        ..lineTo(
          halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep),
        );
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: controller,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: true,
          numberOfParticles: 18,
          maxBlastForce: 28,
          minBlastForce: 12,
          emissionFrequency: 0.08,
          colors: const [
            Color(0xFF40DE8F),
            Color(0xFF6CCFF9),
            Color(0xFFFABE0D),
            Color(0xFFFF8C42),
            Color(0xFFB388FF),
          ],
          createParticlePath: _starPath,
        ),
      ),
    );
  }
}
