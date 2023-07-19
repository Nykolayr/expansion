import 'dart:ui';

import 'package:expansion/domain/repository/game_repository.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:computer/computer.dart';

late UserRepository userRepository;
GameRepository gameRepository = GameRepository();

/// адресс где находится политика безопасности
const politicUrl = 'https://flutter.dev';

/// путь где находится описание объектов для карт
const pathAssetScenes = 'assets/scenes';

/// координаты верхнего главного объекта
Size centerTop = const Size(0, 0);

/// координаты нижнего главного объекта
Size centerDown = const Size(0, 0);

/// размеры эталлоного устройства
const Size standardDeviceSize = Size(392.7, 850.9);

/// размер устройства
Size deviceSize = const Size(0, 0);
late final Computer computer;
// шаг по оси х (5 позиций)
double stepX = standardDeviceSize.width / 6;
// шаг по оси х (7 позиций)
double stepY = (standardDeviceSize.height) / 9;
// максимальная скорость постройки кораблей
double maxbuildShips = 20;
// количество тиков которые нужно пропустить для рендеринга
int maxHoldTic = 2;

// количество тиков для хода врагов
int maxEnemyTic = 400;

// количество тиков для нового астероида
int maxAsteroidTic = 500;

// минимальный ап нашего щита
double minOurShild = 20;
// минимальный ап чужого щита
double minEnemyShild = 20;

// скорость постройки наших кораблей
double ourSpeedRocet = 0.1;
// скорость постройки чужих кораблей
double enemySpeedRocet = 0.1;

// скорость постройки наших кораблей
double ourSpeedResourse = 0.1;
// скорость постройки чужих кораблей
double enemySpeedResourse = 0.1;

// скорость наших кораблей
double ourSpeed = 0.5;
// скорость чужих кораблей
double enemySpeed = 0.5;
// скорость астероидов
double asteroidSpeed = 1;
