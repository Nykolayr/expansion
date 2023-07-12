import 'dart:math';
import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/ships.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// класс астероид, характеризуется точками откуда и куда,
/// сколько сил
class Asteroid extends EntitesObject {
  PointFly target; // координаты цели
  PointFly fly; // текущие координаты астероида
  double angle; // угол наклона астероида
  bool isAttack; // находится ли в столкновении
  double speed; // скорость астероида
  String imagePath; // картинка астероида
  Asteroid({
    required super.index,
    required this.target,
    required this.fly,
    required super.ships,
    required super.coordinates,
    required super.typeStatus,
    required super.size,
    required this.isAttack,
    required this.speed,
    required this.imagePath,
  }) : angle = angleToPoint(fly.coordinates, target.coordinates);

  factory Asteroid.fromRandom(int index) {
    // Выбор случайного края поля
    // 0 - верхний край, 1 - правый край, 2 - нижний край, 3 - левый край
    int edge = Random().nextInt(4);
    PointFly fly = spawnObjectOnEdge(edge);
    int edgeAnother = 0;
    do {
      edgeAnother = Random().nextInt(4);
    } while (edgeAnother == edge);
    PointFly target = spawnObjectOnEdge(edgeAnother);
    int size = Random().nextInt(35) + 20;
    int imageIndex = Random().nextInt(6) + 1;
    return Asteroid(
      index: index,
      target: target,
      fly: fly,
      ships: size + 20,
      coordinates: fly.coordinates,
      typeStatus: TypeStatus.asteroid,
      size: size.toDouble(),
      isAttack: false,
      speed: asteroidSpeed,
      imagePath: 'assets/images/asteroids/ast$imageIndex.png',
    );
  }

  @override
  void update() {
    fly = fly.moveTowards(target, speed * 1);
    coordinates = fly.coordinates;
  }

  @override
  Widget build(
      {required int index,
      required BuildContext context,
      Function(int index)? onAccept}) {
    if (coordinates == target.coordinates && !isAttack) {
      context.read<BattleBloc>().add(ArriveAsteroidEvent(index));
    }
    return Positioned(
      top: coordinates.x - size / 2,
      left: coordinates.y - size / 2,
      child: Image.asset(
        imagePath,
        width: size,
      ),
    );
  }
}

class Field {
  final Point topLeft;
  final Point bottomRight;

  Field(this.topLeft, this.bottomRight);
}

PointFly spawnObjectOnEdge(int edge) {
  Field field = Field(
    const Point(0, 0),
    Point(deviceSize.width, deviceSize.height),
  );
  final random = Random();

  num x = 0;
  num y = 0;

  switch (edge) {
    case 0: // Верхний край
      x = field.topLeft.x +
          random.nextDouble() * (field.bottomRight.x - field.topLeft.x);
      y = field.topLeft.y;
      break;

    case 1: // Правый край
      x = field.bottomRight.x;
      y = field.topLeft.y +
          random.nextDouble() * (field.bottomRight.y - field.topLeft.y);
      break;

    case 2: // Нижний край
      x = field.topLeft.x +
          random.nextDouble() * (field.bottomRight.x - field.topLeft.x);
      y = field.bottomRight.y;
      break;

    case 3: // Левый край
      x = field.topLeft.x;
      y = field.topLeft.y +
          random.nextDouble() * (field.bottomRight.y - field.topLeft.y);
      break;
  }

  return PointFly(Point(y, x));
}
