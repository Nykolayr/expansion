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

  init() async {
    String? data = await LocalData().loadJsonMaps();

    if (data != '{}' && data != '') {
      List json = jsonDecode(data!);
      scenes = List<Scene>.from(json.map((x) => Scene.fromJson(x)));
    } else {
      List<dynamic> json = await Api.loadJsonScenes();
      List<Scene> temp = List<Scene>.from(json.map((x) => Scene.fromJson(x)));
      // переделываем все сцены по 5 штук змейкой
      int l = temp.length ~/ 10 + 1;
      int k = 0;
      int s = 4;

      outerloop:
      for (var m = 0; m < l; m++) {
        for (var i = 0; i < 5; i++) {
          temp[k].id = k;
          scenes.add(temp[k]);
          k++;
          if (k > temp.length - 1) break outerloop;
        }
        int j = k + s;
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
        TypeScene typeScene = TypeScene.first;
        switch (index % 5) {
          case 1:
            typeScene = TypeScene.second;
            break;
          case 2:
            typeScene = TypeScene.third;
            break;
          case 3:
            typeScene = TypeScene.fourth;
            break;
          case 4:
            typeScene = TypeScene.fifth;
        }
        scenes[index].typeScene = typeScene;
      }
      await LocalData().saveJsonMaps(scenes);
    }
  }

  loadMap() async {
    bases.clear();
    ships.clear();
    Map<String, dynamic> json =
        await Api.loadJsonBase(Get.find<UserRepository>().user.mapClassic);
    List<Base> planets =
        List<Base>.from(json["neutral"].map((x) => Base.fromJson(x)));

    BaseShip enemyMainShip = BaseShip.fromJson(json["mainShipEnemy"]);
    BaseShip ourMainShip = BaseShip.fromJson(json["mainShipOur"]);
    for (int k = 0; k < planets.length; k++) {
      planets[k].index = k;
    }
    enemyMainShip.index = planets.length;
    ourMainShip.index = planets.length + 1;
    bases.addAll(planets);
    bases.add(enemyMainShip);
    bases.add(ourMainShip);
  }
}
