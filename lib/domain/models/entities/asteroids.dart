import 'dart:math';
import 'package:expansion/data/game_data.dart';
import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/ships.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/ui/widgets/animations_sprites.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// класс астероид, характеризуется точками откуда и куда,
/// сколько сил
class Asteroid extends EntitesObject {
  PointFly target; // координаты цели
  PointFly fly; // текущие координаты астероида
  double angle; // угол наклона астероида
  bool isAttack = false; // находится ли в столкновении
  bool isSend = false; // отослали ли в блок
  double speed; // скорость астероида
  String imagePath; // картинка астероида'
  int? indexBase; // индекс базы в которую врезался астероид
  int? indexShip; // индекс отряда кораблей в которую врезался астероид
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
    int size = Random().nextInt(15) + 20;
    int imageIndex = Random().nextInt(6) + 1;
    return Asteroid(
      index: index,
      target: target,
      fly: fly,
      ships: size,
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
    if (isAttack) return;
    fly = fly.moveTowards(target, speed * 1);
    coordinates = fly.coordinates;
    indexBase = checkCollisionBase(this);
    indexShip = checkCollisionBase(this, isBase: false);
    if (indexBase != null || indexShip != null) {
      isAttack = true;
    }
  }

  @override
  Widget build(
      {required int index,
      required BuildContext context,
      Function(int index)? onAccept}) {
    if (coordinates == target.coordinates && !isAttack) {
      context
          .read<BattleBloc>()
          .add(ArriveAsteroidEvent(index, indexBase, indexShip));
    }
    if (isAttack && !isSend) {
      isSend = true;
      Future.delayed(const Duration(seconds: 1), () {
        context
            .read<BattleBloc>()
            .add(ArriveAsteroidEvent(index, indexBase, indexShip));
      });
    }
    ImageAnimation animation = ImageAnimation(
      animationsGame: AnimationsGame.explosion,
      numberOfImages: 9,
      duration: 200,
      size: size,
    );

    return Positioned(
      top: coordinates.x - size / 2,
      left: coordinates.y - size / 2,
      child: isAttack
          ? animation
          : Image.asset(
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
    Point(deviceSize.height, deviceSize.width),
  );
  final random = Random();

  num x = 0;
  num y = 0;

  switch (edge) {
    case 0: // Верхний край
      x = field.topLeft.x +
          random.nextDouble() * (field.bottomRight.x - field.topLeft.x) -
          50;
      y = field.topLeft.y;
      break;

    case 1: // Правый край
      x = field.bottomRight.x;
      y = field.topLeft.y +
          random.nextDouble() * (field.bottomRight.y - field.topLeft.y) -
          50;
      break;

    case 2: // Нижний край
      x = field.topLeft.x +
          random.nextDouble() * (field.bottomRight.x - field.topLeft.x) -
          50;
      y = field.bottomRight.y;
      break;

    case 3: // Левый край
      x = field.topLeft.x;
      y = field.topLeft.y +
          random.nextDouble() * (field.bottomRight.y - field.topLeft.y) -
          50;
      break;
  }
  return PointFly(Point(x, y));
}

/// проверяет, произошло ли столкновение с отрядом кораблей
int? checkCollisionBase(Asteroid ast, {isBase = true}) {
  GameData gameData = gameRepository.gameData;
  for (EntitesObject base in isBase ? gameData.bases : gameData.ships) {
    if (base.typeStatus == TypeStatus.asteroid) continue;

    Point point = isBase
        ? Point(base.coordinates.y + base.size / 2,
            base.coordinates.x + base.size / 2)
        : base.coordinates;
    PointFly baseFly = PointFly(point);
    double distance = ast.fly.distanceTo(baseFly);

    if (distance < ast.size / 2 + base.size / 2 - 1) {
      return base.index; // Столкновение произошло
    }
  }

  return null; // Столкновение не произошло
}
