import 'dart:ui';

import 'package:expansion/domain/repository/game_repository.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:computer/computer.dart';

late UserRepository userRepository;
GameRepository gameRepository = GameRepository();

/// Базовый балл за победу
const int baseScore = 1000;

/// Идеальное время победы в секундах
const int idealTimeInSeconds = 60;

/// Пенальти за каждую секунду сверх идеального времени
const int penaltyPerSecond = 50;

/// адресс где находится политика безопасности
const politicUrl = 'https://flutter.dev';

/// путь где находится описание объектов для карт
const pathAssetScenes = 'assets/scenes';

/// координаты верхнего главного объекта
const Size centerTop = Size(0, 0);

/// координаты нижнего главного объекта
const Size centerDown = Size(0, 0);

/// размеры эталлоного устройства
const Size standardDeviceSize = Size(392.7, 850.9);

/// размер устройства
Size deviceSize = const Size(0, 0);
late final Computer computer;
// шаг по оси х (5 позиций)
final double stepX = standardDeviceSize.width / 6;
// шаг по оси х (7 позиций)
final double stepY = standardDeviceSize.height / 9;
// количество тиков которые нужно пропустить для рендеринга
const maxHoldTic = 2;

// количество тиков для нового астероида
const maxAsteroidTic = 500;
// скорость астероидов
const double asteroidSpeed = 1;
// умножитель скорости для кораблей
const speedShipsMult = 1.4;
// делитель скорости
const delSpeedBuild = 8;
// Множитель, который определяет диапазон очков
double scoreMultiplier = 200;
