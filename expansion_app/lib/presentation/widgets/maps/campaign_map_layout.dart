import 'package:flutter/material.dart';

/// Геометрия сетки одной туманности на карте (5×6 при полной).
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
}
