import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

class Ship extends EntitesObject {
  int index;
  int toIndex;
  double speed;
  double distance;
  Point target;
  Point fly;
  Ship({
    required this.index,
    required this.toIndex,
    required this.distance,
    required this.speed,
    required this.target,
    required this.fly,
    required super.ships,
    required super.coordinates,
    required super.typeStatus,
  });

  @override
  void update() {
    fly = fly.moveTowards(target, speed * 3);
    coordinates = Size(fly.y, fly.x);
  }

  @override
  Widget build(
      {required int? index,
      required BuildContext context,
      Function()? click,
      Function(int sender)? onAccept}) {
    if (coordinates == Size(target.y, target.x)) {
      print('object');
      context.read<BattleBloc>().add(ArriveShipsEvent(index!, toIndex));
    }
    return Positioned(
      top: coordinates.height,
      left: coordinates.width,
      child: Container(
        height: 40,
        width: 40,
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
      ),
    );
  }

  @override
  Widget getText() {
    return const SizedBox.shrink();
  }
}

class Point {
  double x;
  double y;

  Point(this.x, this.y);

  double distanceTo(Point other) {
    double dx = x - other.x;
    double dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }

  Point moveTowards(Point target, double distance) {
    double totalDistance = distanceTo(target);
    if (totalDistance <= distance) {
      return target;
    }
    double ratio = distance / totalDistance;
    double dx = (target.x - x) * ratio;
    double dy = (target.y - y) * ratio;
    return Point(x + dx, y + dy);
  }
}
