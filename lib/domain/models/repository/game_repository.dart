import 'package:expansion/data/game_data.dart';

class GameRepository {
  GameData gameData = GameData();

  static final GameRepository _gameRepository = GameRepository._internal();
  factory GameRepository() {
    return _gameRepository;
  }
  GameRepository._internal();
}
