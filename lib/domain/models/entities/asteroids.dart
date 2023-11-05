import 'dart:math';
import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/ships.dart';
import 'package:expansion/domain/repository/game_repository.dart';
import 'package:expansion/utils/value.dart';
import 'package:get/get.dart';

/// Класс астероида, наследуется от базового класса игровых
/// объектов [EntitesObject].
/// Содержит свойства, описывающие состояние и поведение астероида.
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
    final edge = Random().nextInt(4);
    final fly = spawnObjectOnEdge(edge);
    var edgeAnother = 0;
    do {
      edgeAnother = Random().nextInt(4);
    } while (edgeAnother == edge);
    final target = spawnObjectOnEdge(edgeAnother);
    final size = Random().nextInt(15) + 20;
    final imageIndex = Random().nextInt(6) + 1;
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

  /// Обновляет положение астероида в каждом кадре.
  /// Проверяет наличие столкновений с базами и кораблями,
  /// устанавливая для параметра "Атака" значение true
  /// в случае возникновения столкновения.
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
}

/// Определяет границы игрового поля.
/// Используется для генерации объектов на экране.
class Field {
  final Point topLeft;
  final Point bottomRight;

  Field(this.topLeft, this.bottomRight);
}

/// Генерирует случайную точку появления объекта на одной из границ экрана.
///
/// Параметры:
///
/// * `edge` - номер границы экрана:
///   0 - верхняя граница,
///   1 - правая граница,
///   2 - нижняя граница,
///   3 - левая граница.
///
/// Возвращает объект `PointFly` со случайными координатами x и y на заданной границе.
PointFly spawnObjectOnEdge(int edge) {
  final field = Field(
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

    case 1: // Правый край
      x = field.bottomRight.x;
      y = field.topLeft.y +
          random.nextDouble() * (field.bottomRight.y - field.topLeft.y) -
          50;

    case 2: // Нижний край
      x = field.topLeft.x +
          random.nextDouble() * (field.bottomRight.x - field.topLeft.x) -
          50;
      y = field.bottomRight.y;

    case 3: // Левый край
      x = field.topLeft.x;
      y = field.topLeft.y +
          random.nextDouble() * (field.bottomRight.y - field.topLeft.y) -
          50;
  }
  return PointFly(Point(x, y));
}

/// проверяет, произошло ли столкновение с отрядом кораблей
int? checkCollisionBase(Asteroid ast, {bool isBase = true}) {
  final gameData = Get.find<GameRepository>();
  for (final base in isBase ? gameData.bases : gameData.ships) {
    if (base.typeStatus == TypeStatus.asteroid) continue;

    final point = isBase
        ? Point(base.coordinates.y + base.size / 2,
            base.coordinates.x + base.size / 2)
        : base.coordinates;
    final baseFly = PointFly(point);
    final distance = ast.fly.distanceTo(baseFly);

    if (distance < ast.size / 2 + base.size / 2 - 1) {
      return base.index; // Столкновение произошло
    }
  }

  return null; // Столкновение не произошло
}
