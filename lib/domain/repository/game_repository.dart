import 'dart:convert';

import 'package:expansion/Api/api.dart';
import 'package:expansion/data/local_data.dart';
import 'package:expansion/domain/models/entities/base.dart';
import 'package:expansion/domain/models/entities/base_ships.dart';
import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/domain/models/maps/scenes.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:get/get.dart';

/// класс игровых сущностей которые загружаются из апи или ассета
///  List<Planet> - список планет, system - название системы и звезды
class GameRepository extends GetxController {
  List<BaseObject> bases = [];
  List<EntitesObject> ships = [];
  List<Scene> scenes = [];

  static final GameRepository _gameRepository = GameRepository._internal();
  factory GameRepository() {
    return _gameRepository;
  }
  GameRepository._internal();

  Future<void> init() async {
    final data = await LocalData().loadJsonMaps();

    if (data != '{}' && data != '') {
      final json = jsonDecode(data!) as List<Map<String, dynamic>>;
      scenes = json.map(Scene.fromJson).toList();
    } else {
      final json = jsonDecode(data!) as List<Map<String, dynamic>>;
      final temp = json.map(Scene.fromJson).toList();
      // переделываем все сцены по 5 штук змейкой
      final l = temp.length ~/ 10 + 1;
      var k = 0;
      var s = 4;

      outerloop:
      for (var m = 0; m < l; m++) {
        for (var i = 0; i < 5; i++) {
          temp[k].id = k;
          scenes.add(temp[k]);
          k++;
          if (k > temp.length - 1) break outerloop;
        }
        var j = k + s;
        if (j > temp.length) {
          j = temp.length - 1;
          s = temp.length - k;
        }
        for (var z = 0; z < s + 1; z++) {
          temp[j - z].id = j - z;
          scenes.add(temp[j - z]);
          k++;
          if (k > temp.length - 1) break outerloop;
        }
      }

      for (var index = 0; index < scenes.length; index++) {
        var typeScene = TypeScene.first;
        switch (index % 5) {
          case 1:
            typeScene = TypeScene.second;
          case 2:
            typeScene = TypeScene.third;
          case 3:
            typeScene = TypeScene.fourth;
          case 4:
            typeScene = TypeScene.fifth;
        }
        scenes[index].typeScene = typeScene;
      }
      await LocalData().saveJsonMaps(scenes);
    }
  }

  Future<void> loadMap() async {
    bases.clear();
    ships.clear();
    final json =
        await Api.loadJsonBase(Get.find<UserRepository>().user.mapClassic);
    final jsonObj = json!['neutral'] as List<Map<String, dynamic>>;

    final planets = jsonObj.map(Base.fromJson);

    final enemyMainShip =
        BaseShip.fromJson(json['mainShipEnemy'] as Map<String, dynamic>);
    final ourMainShip =
        BaseShip.fromJson(json['mainShipOur'] as Map<String, dynamic>);
    for (var k = 0; k < planets.length; k++) {
      planets.elementAt(k).index = k;
    }
    enemyMainShip.index = planets.length;
    ourMainShip.index = planets.length + 1;
    bases.addAll([...planets, enemyMainShip, ourMainShip]);
  }
}
