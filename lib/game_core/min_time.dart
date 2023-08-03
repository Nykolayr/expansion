import 'dart:math';

import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/utils/value.dart';

int calculateMinTime() {
  List<BaseObject> bases = gameRepository.gameData.bases;
  Map<Point, int> timeToCapture = {};
  Map<Point, int> timeToBuild =
      {}; // Время на накопление кораблей для захвата базы

  for (var base in bases) {
    timeToCapture[base.coordinates] = double.infinity
        .toInt(); // Инициализируем время на захват всех баз как бесконечность
    timeToBuild[base.coordinates] =
        0; // Начальное время на накопление кораблей - 0
  }

  // Начальная база считается захваченной сразу, время на захват - 0
  timeToCapture[bases[0].coordinates] = 0;

  while (true) {
    Point currentCoordinates = const Point(0, 0);
    int minTime = double.infinity.toInt();

    // Находим базу с минимальным временем на захват
    for (var base in bases) {
      if (timeToCapture[base.coordinates]! < minTime) {
        currentCoordinates = base.coordinates;
        minTime = timeToCapture[base.coordinates]!;
      }
    }

    // Если все базы были захвачены, прерываем цикл
    if (minTime == double.infinity.toInt()) break;

    // Обновляем время на захват соседних баз
    for (var base in bases) {
      int distance = ((currentCoordinates.x - base.coordinates.x).abs() +
          (currentCoordinates.y - base.coordinates.y).abs()) as int;
      int travelTime = (distance * 3) ~/ TypeStatus.our.shipSpeed;
      int nextTime = max(minTime + travelTime, timeToBuild[base.coordinates]!);

      if (nextTime < timeToCapture[base.coordinates]!) {
        timeToCapture[base.coordinates] = nextTime;
        timeToBuild[base.coordinates] =
            (nextTime + TypeStatus.our.shipSpeed * 3).toInt();
      }
    }
  }

  // Находим максимальное время на захват всех баз
  int maxTime = 0;
  for (var base in bases) {
    maxTime = max(maxTime, timeToCapture[base.coordinates]!);
  }

  return maxTime;
}
