import 'package:flutter/material.dart';

/// Геометрия сетки карты: [cellExtent] = контент без «пустоты» внизу ячейки.
abstract final class CampaignMapLayout {
  static const int columns = 5;
  static const double crossSpacing = 8;

  /// Между рядами — только это значение (не путать с пустым местом в ячейке).
  static const double mainAxisSpacing = 0;

  static const EdgeInsets padding = EdgeInsets.fromLTRB(16, 8, 16, 8);

  static const double sceneHeight = 54;
  static const double badgeTop = 5;
  static const double titleBlockHeight = 26;
  static const double sceneToTitleGap = 2;

  /// Высота ячейки = ровно блок указателя + подпись.
  static const double cellExtent =
      sceneHeight + sceneToTitleGap + titleBlockHeight;

  /// Точка стыка линий у подножия `scene.svg` (центр «хаба»).
  static const double hubOffsetFromCellTop = 43;

  static List<int> snakeOrder(int missionCount) {
    final order = <int>[];
    final rows = (missionCount + columns - 1) ~/ columns;
    for (var row = 0; row < rows; row++) {
      final start = row * columns + 1;
      final end = (start + columns - 1).clamp(1, missionCount);
      if (row.isEven) {
        for (var id = start; id <= end; id++) {
          order.add(id);
        }
      } else {
        for (var id = end; id >= start; id--) {
          order.add(id);
        }
      }
    }
    return order;
  }

  static Offset hubCenterForMission(
    int missionId,
    Size canvasSize, {
    required int missionCount,
  }) {
    final index = missionId - 1;
    final row = index ~/ columns;
    final col = index % columns;
    final cellW = (canvasSize.width - padding.horizontal - crossSpacing * (columns - 1)) /
        columns;
    final left = padding.left + col * (cellW + crossSpacing) + cellW / 2;
    final top = padding.top + row * (cellExtent + mainAxisSpacing) + hubOffsetFromCellTop;
    return Offset(left, top);
  }
}
