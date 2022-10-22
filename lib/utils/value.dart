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

/// координаты центра звезды
Size centerStar = const Size(0, 0);

/// размеры эталлоного устройства
const Size standardDeviceSize = Size(392.7, 775.3);

/// размер устройства
Size deviceSize = const Size(0, 0);
late final Computer computer;

/// коэффициент отношения между эталлонным и этим устройством
Size ratioXY = const Size(0, 0);
