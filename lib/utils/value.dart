import 'dart:ui';

import 'package:expansion/domain/models/repository/game_repository.dart';
import 'package:expansion/domain/models/repository/user_repository.dart';
import 'package:computer/computer.dart';

late UserRepository userRepository;
GameRepository gameRepository = GameRepository();

const politicUrl = 'https://flutter.dev';
const pathAssetScenes = 'assets/scenes';

late Size center;
late Size size;
late final Computer computer;
