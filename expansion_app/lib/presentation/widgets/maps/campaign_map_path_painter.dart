import 'package:flutter/material.dart';

import 'package:expansion/core/themes/expansion_colors.dart';
import 'package:expansion/presentation/widgets/maps/campaign_map_layout.dart';

/// Линии пути под тайлами: зелёные между пройденными, красная к текущей.
class CampaignMapPathPainter extends CustomPainter {
  CampaignMapPathPainter({
    required this.missionCount,
    required this.currentMissionId,
  });

  final int missionCount;
  final int currentMissionId;

  @override
  void paint(Canvas canvas, Size size) {
    if (missionCount < 2 || currentMissionId < 1) return;

    final order = CampaignMapLayout.snakeOrder(missionCount);
    if (order.length < 2) return;

    final greenPaint = Paint()
      ..color = ExpansionColors.green.withValues(alpha: 0.9)
      ..strokeWidth = 2.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final redPaint = Paint()
      ..color = ExpansionColors.red.withValues(alpha: 0.9)
      ..strokeWidth = 2.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Offset hub(int id) => CampaignMapLayout.hubCenterForMission(
          id,
          size,
          missionCount: missionCount,
        );

    for (var i = 0; i < order.length - 1; i++) {
      final fromId = order[i];
      final toId = order[i + 1];

      if (toId > currentMissionId) continue;
      if (fromId > currentMissionId) continue;

      final paint = toId < currentMissionId
          ? greenPaint
          : (toId == currentMissionId && fromId < currentMissionId)
              ? redPaint
              : null;
      if (paint == null) continue;

      final from = hub(fromId);
      final to = hub(toId);
      canvas.drawLine(from, to, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CampaignMapPathPainter oldDelegate) =>
      oldDelegate.missionCount != missionCount ||
      oldDelegate.currentMissionId != currentMissionId;
}
