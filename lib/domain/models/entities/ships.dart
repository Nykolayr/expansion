import 'package:expansion/data/game_data.dart';
import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/ui/widgets/widgets.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Ship extends EntitesObject {
  int fromIndex; // индекс базы с которой летит корабль
  int toIndex; // индекс базы на которую летит корабль
  double speed; // скорость корабля
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
    required this.speed,
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
    fly = fly.moveTowards(target, speed * 3);
    distanceCurrent = fly.distanceTo(target);
    coordinates = fly.coordinates;
    indexShip = checkCollisionShip(this);
    if (indexShip != null) {
      isAttack = true;
    }
  }

  @override
  Widget build(
      {required int? index,
      required BuildContext context,
      Function()? click,
      Function(int sender)? onAccept}) {
    if (coordinates == target.coordinates && !isAttack) {
      context
          .read<BattleBloc>()
          .add(ArriveShipsEvent(index!, toIndex, indexShip));
    }
    if (isAttack && !isSend && indexShip != null && index != null) {
      isSend = true;
      context.read<BattleBloc>().add(BattleShipsEvent(indexShip!, index));
    }
    return Positioned(
      top: coordinates.x - size / 2,
      left: coordinates.y - size / 2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          isAttack
              ? IconRotate(size: size)
              : Transform.rotate(
                  angle: angle,
                  child: Container(
                    height: size,
                    width: size,
                    padding: const EdgeInsets.all(4),
                    decoration: typeStatus.boxDecor,
                    child: SvgPicture.asset(
                      typeStatus.shipImage,
                      colorFilter:
                          ColorFilter.mode(typeStatus.color, BlendMode.srcIn),
                      width: 40.w,
                    ),
                  ),
                ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                color: typeStatus.color,
              ),
              child: Text(
                ships.toString(),
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

double angleToPoint(Point p1, Point p2) {
  return atan2(p2.x - p1.x, p2.y - p1.y) + 1.57;
}

class PointFly {
  Point<num> coordinates;

  PointFly(this.coordinates);

  double distanceTo(PointFly other) {
    num dx = coordinates.x - other.coordinates.x;
    num dy = coordinates.y - other.coordinates.y;
    return sqrt(dx * dx + dy * dy);
  }

  PointFly moveTowards(PointFly target, double distance) {
    double totalDistance = distanceTo(target);
    if (totalDistance <= distance) {
      return target;
    }
    double ratio = distance / totalDistance;
    double dx = (target.coordinates.x - coordinates.x) * ratio;
    double dy = (target.coordinates.y - coordinates.y) * ratio;
    return PointFly(Point(coordinates.x + dx, coordinates.y + dy));
  }
}

/// проверяет, произошло ли столкновение с вражеским отрядом кораблей
int? checkCollisionShip(Ship shipOur) {
  GameData gameData = gameRepository.gameData;
  for (EntitesObject ship in gameData.ships) {
    if (ship.typeStatus == shipOur.typeStatus ||
        ship.typeStatus == TypeStatus.asteroid ||
        ship.index == shipOur.index) continue;
    Point point = ship.coordinates;
    PointFly baseFly = PointFly(point);
    double distance = shipOur.fly.distanceTo(baseFly);
    if (distance < shipOur.size / 2 + ship.size / 2 - 1) {
      // print('typeStatus1 ${ship.index} ${shipOur.index} == $distance');
      // print('typeStatus2 ${ship.typeStatus} ${shipOur.typeStatus} == ');
      return ship.index; // Столкновение произошло
    }
  }

  return null; // Столкновение не произошло
}
