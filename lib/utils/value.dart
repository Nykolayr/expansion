import 'dart:ui';

import 'package:expansion/domain/models/repository/game_repository.dart';
import 'package:expansion/domain/models/repository/user_repository.dart';
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
const Size standardDeviceSize = Size(392.7, 822.5);

/// размер устройства
Size deviceSize = const Size(0, 0);
late final Computer computer;

/// коэффициент отношения между эталлонным и этим устройством
Size ratioXY = const Size(0, 0);

// шаг по оси х (5 позиций)
double stepX = standardDeviceSize.width / 6;
// шаг по оси х (7 позиций)
double stepY = (standardDeviceSize.height - 80) / 8;
// максимальная скорость постройки кораблей
double maxbuildShips = 20;
