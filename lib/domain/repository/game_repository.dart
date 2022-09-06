import 'package:expansion/data/game_data.dart';

class GameRepository {
  final GameData _gameData = GameData();
  static final GameRepository _gameRepository = GameRepository._internal();
  factory GameRepository() {
    return _gameRepository;
  }
  GameRepository._internal();

  Future<String> getMap() async {
    return await _gameData.loadMap();
  }
}
