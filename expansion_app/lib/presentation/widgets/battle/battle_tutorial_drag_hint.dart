import 'package:flutter/material.dart';

import 'package:expansion/core/constants/game_layout.dart';
import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/entities/battle_snapshot.dart';
import 'package:expansion/domain/enums/battle_side.dart';
import 'package:expansion/presentation/bloc/battle/battle_state.dart';

/// Анимация подсказки на поле — не перехватывает касания.
class BattleTutorialDragHint extends StatefulWidget {
  const BattleTutorialDragHint({
    required this.snapshot,
    required this.step,
    this.targetBaseId,
    super.key,
  });

  final BattleSnapshot snapshot;
  final MissionTutorialStep step;
  final int? targetBaseId;

  @override
  State<BattleTutorialDragHint> createState() => _BattleTutorialDragHintState();
}

class _BattleTutorialDragHintState extends State<BattleTutorialDragHint>
    with SingleTickerProviderStateMixin {
  static const double _spacing = 4;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellW = (constraints.maxWidth -
                _spacing * (kBattleColumns - 1)) /
            kBattleColumns;
        final cellH = (constraints.maxHeight -
                _spacing * (kBattleRows - 1)) /
            kBattleRows;

        if (widget.step == MissionTutorialStep.drag) {
          final from = _playerOrigin(widget.snapshot);
          final to = from == null ? null : _tutorialTarget(widget.snapshot, from);
          if (from == null || to == null) return const SizedBox.shrink();

          final start = _cellCenter(from.x, from.y, cellW, cellH);
          final end = _cellCenter(to.x, to.y, cellW, cellH);

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final t = Curves.easeInOut.transform(_controller.value);
              final finger = Offset.lerp(start, end, t)!;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomPaint(
                    size: constraints.biggest,
                    painter: _SwipeLinePainter(
                      start: start,
                      end: end,
                      progress: t,
                    ),
                  ),
                  Positioned(
                    left: finger.dx - 18,
                    top: finger.dy - 18,
                    child: _fingerIcon(),
                  ),
                ],
              );
            },
          );
        }

        if (widget.step == MissionTutorialStep.captureHint) {
          final target = _baseById(widget.targetBaseId);
          if (target == null) return const SizedBox.shrink();
          final center = _cellCenter(target.x, target.y, cellW, cellH);

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final pulse = 0.65 + 0.35 * (1 + Curves.easeInOut.transform(_controller.value)) / 2;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: center.dx - 28 * pulse,
                    top: center.dy - 28 * pulse,
                    child: Container(
                      width: 56 * pulse,
                      height: 56 * pulse,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ExpansionColors.accent.withValues(alpha: 0.75),
                          width: 2.5,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: center.dx - 18,
                    top: center.dy - 18,
                    child: _fingerIcon(),
                  ),
                ],
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _fingerIcon() {
    return Icon(
      Icons.touch_app_rounded,
      size: 36,
      color: ExpansionColors.accent.withValues(alpha: 0.95),
      shadows: const [Shadow(color: Colors.black87, blurRadius: 6)],
    );
  }

  Offset _cellCenter(int x, int y, double cellW, double cellH) {
    final left = (x - 1) * (cellW + _spacing);
    final top = (y - 1) * (cellH + _spacing);
    return Offset(left + cellW / 2, top + cellH / 2);
  }

  BattleBase? _baseById(int? id) {
    if (id == null) return null;
    return widget.snapshot.baseById(id);
  }

  BattleBase? _playerOrigin(BattleSnapshot snapshot) {
    for (final base in snapshot.playerBases) {
      if (base.isCommandBase) return base;
    }
    final list = snapshot.playerBases.toList();
    return list.isEmpty ? null : list.first;
  }

  BattleBase? _tutorialTarget(BattleSnapshot snapshot, BattleBase from) {
    BattleBase? best;
    var bestDist = double.infinity;
    for (final base in snapshot.bases) {
      if (base.side != BattleSide.neutral) continue;
      final dx = (base.x - from.x).toDouble();
      final dy = (base.y - from.y).toDouble();
      final dist = dx * dx + dy * dy;
      if (dist < bestDist) {
        bestDist = dist;
        best = base;
      }
    }
    return best;
  }
}

class _SwipeLinePainter extends CustomPainter {
  _SwipeLinePainter({
    required this.start,
    required this.end,
    required this.progress,
  });

  final Offset start;
  final Offset end;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = ExpansionColors.accent.withValues(alpha: 0.55)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, linePaint);

    final arrowTip = Offset.lerp(start, end, progress.clamp(0.05, 1.0))!;
    final dir = (end - start);
    if (dir.distance < 1) return;
    final unit = dir / dir.distance;
    final normal = Offset(-unit.dy, unit.dx);
    const arrowSize = 10.0;
    final p1 = arrowTip - unit * arrowSize + normal * (arrowSize * 0.55);
    final p2 = arrowTip - unit * arrowSize - normal * (arrowSize * 0.55);
    final arrow = Paint()
      ..color = ExpansionColors.accent.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    canvas.drawPath(
      Path()
        ..moveTo(arrowTip.dx, arrowTip.dy)
        ..lineTo(p1.dx, p1.dy)
        ..lineTo(p2.dx, p2.dy)
        ..close(),
      arrow,
    );
  }

  @override
  bool shouldRepaint(covariant _SwipeLinePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
