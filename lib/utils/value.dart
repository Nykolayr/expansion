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
const Size standardDeviceSize = Size(392.7, 775.3);

/// размер устройства
Size deviceSize = const Size(0, 0);
late final Computer computer;

/// коэффициент отношения между эталлонным и этим устройством
Size ratioXY = const Size(0, 0);

/// координаты по оси х, которые можно назначать для нейтральных баз
List<double> coordinatListX = [34.27, 102.81, 171.35, 239.89, 308.43];

/// координаты по оси y, которые можно назначать для нейтральных баз
List<double> coordinatListY = [
  110.0,
  202.55,
  295.1,
  387.65,
  480.2,
  572.75,
  665.3
];
