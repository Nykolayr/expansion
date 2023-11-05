import 'dart:math';

import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/repository/game_repository.dart';
import 'package:expansion/utils/value.dart';
import 'package:get/get.dart';

/// класс корабля для отображение в битве
class Ship extends EntitesObject {
  int fromIndex; // индекс базы с которой летит корабль
  int toIndex; // индекс базы на которую летит корабль
  double distance; // дистанция от нашей базы до базы на которую летит корабль
  PointFly target; // координаты цели
  PointFly fly; // текущие координаты корабля
  double distanceCurrent; //текущия дистанция до базы на которую летит корабль
  double angle; // угол наклона корабля
  bool isAttack; // находится ли в атаке
  bool isSend = false; // отослали ли в блок
  int?
      indexShip; // индекс вражеского отряда кораблей с которым столкнулся  отряд
  Ship({
    required super.index,
    required this.fromIndex,
    required this.toIndex,
    required this.distance,
    required this.target,
    required this.fly,
    required super.ships,
    required super.coordinates,
    required super.typeStatus,
    required super.size,
    required this.distanceCurrent,
    required this.isAttack,
  }) : angle = angleToPoint(fly.coordinates, target.coordinates);

  @override
  void update() {
    fly = fly.moveTowards(target, typeStatus.shipSpeed * speedShipsMult);
    distanceCurrent = fly.distanceTo(target);
    coordinates = fly.coordinates;
    indexShip = checkCollisionShip(this);
    if (indexShip != null) {
      isAttack = true;
    }
  }
}

double angleToPoint(Point p1, Point p2) {
  return atan2(p2.x - p1.x, p2.y - p1.y) + 1.57;
}

class PointFly {
  Point<num> coordinates;

  PointFly(this.coordinates);

  double distanceTo(PointFly other) {
    final dx = coordinates.x - other.coordinates.x;
    final dy = coordinates.y - other.coordinates.y;
    return sqrt(dx * dx + dy * dy);
  }

  PointFly moveTowards(PointFly target, double distance) {
    final totalDistance = distanceTo(target);
    if (totalDistance <= distance) {
      return target;
    }
    final ratio = distance / totalDistance;
    final dx = (target.coordinates.x - coordinates.x) * ratio;
    final dy = (target.coordinates.y - coordinates.y) * ratio;
    return PointFly(Point(coordinates.x + dx, coordinates.y + dy));
  }
}

/// проверяет, произошло ли столкновение с вражеским отрядом кораблей
int? checkCollisionShip(Ship shipOur) {
  final gameData = Get.find<GameRepository>();
  for (final ship in gameData.ships) {
    if (ship.typeStatus == shipOur.typeStatus ||
        ship.typeStatus == TypeStatus.asteroid ||
        ship.index == shipOur.index) continue;
    final point = ship.coordinates;
    final baseFly = PointFly(point);
    final distance = shipOur.fly.distanceTo(baseFly);
    if (distance < shipOur.size / 2 + ship.size / 2 - 1) {
      return ship.index; // Столкновение произошло
    }
  }

  return null; // Столкновение не произошло
}
