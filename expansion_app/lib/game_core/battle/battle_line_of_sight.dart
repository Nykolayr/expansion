import 'package:expansion/domain/entities/battle_base.dart';
import 'package:expansion/domain/entities/battle_snapshot.dart';

/// Проверка прямой на сетке 1-based (как в legacy JSON).
abstract final class BattleLineOfSight {
  static bool isClear(
    BattleSnapshot snapshot,
    BattleBase from,
    BattleBase to,
  ) {
    if (from.id == to.id) return false;

    for (final cell in _cellsOnLine(from.x, from.y, to.x, to.y)) {
      final occupant = snapshot.baseAt(cell.$1, cell.$2);
      if (occupant != null &&
          occupant.id != from.id &&
          occupant.id != to.id) {
        return false;
      }
    }
    return true;
  }

  static Iterable<(int, int)> _cellsOnLine(int x0, int y0, int x1, int y1) sync* {
    var x = x0;
    var y = y0;
    final dx = (x1 - x0).abs();
    final dy = (y1 - y0).abs();
    final sx = x0 < x1 ? 1 : -1;
    final sy = y0 < y1 ? 1 : -1;
    var err = dx - dy;

    while (true) {
      if (x != x0 || y != y0) {
        yield (x, y);
      }
      if (x == x1 && y == y1) break;
      final e2 = 2 * err;
      if (e2 > -dy) {
        err -= dy;
        x += sx;
      }
      if (e2 < dx) {
        err += dx;
        y += sy;
      }
    }
  }
}
