import 'dart:convert';
import 'dart:math';

import 'package:expansion/Api/api.dart';
import 'package:expansion/data/local_data.dart';
import 'package:expansion/domain/models/entities/base.dart';
import 'package:expansion/domain/models/entities/base_ships.dart';
import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/domain/models/maps/scenes.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:expansion/utils/function.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    await loadScenesFromJson();
    await saveScenesToLocal();
  }

  loadScenesFromJson() async {
    // String? data = await LocalData().loadJsonMaps();

    // if (data != '{}' && data != '') {
    //   List json = jsonDecode(data!);
    //   scenes = List<Scene>.from(json.map((x) => Scene.fromJson(x)));
    // } else {
    Map<String, dynamic> json = await Api.loadJsonScenes();
    scenes = List<Scene>.from(json["scenes"].map((x) => Scene.fromJson(x)));
    shuffle(scenes, start: 1);
    double xOffset = 5.0;
    double yOffset = 100.0;
    double screenHeight = 150.0;
    double width = deviceSize.width - 10;
    int numScenesPerRow = width ~/ (width / 5.0);
    Random random = Random();
    for (int i = 0; i < scenes.length; i++) {
      if (i % numScenesPerRow == 0 && i != 0) {
        yOffset -= 20.0 + random.nextDouble() * 10;
      } else if (i % numScenesPerRow == 1) {
        yOffset += 20.0 + random.nextDouble() * 10;
        ;
      } else if (i % numScenesPerRow == 2) {
        yOffset -= 20.0 + random.nextDouble() * 10;
        ;
      } else if (i % numScenesPerRow == 3) {
        yOffset += 20.0 + random.nextDouble() * 10;
        ;
      } else if (i % numScenesPerRow == 4) {
        yOffset -= 20 + random.nextDouble() * 10;
      }
      scenes[i].y = yOffset;
      scenes[i].x = xOffset;
      xOffset += width / numScenesPerRow;

      if ((i + 1) % numScenesPerRow == 0) {
        xOffset = 5.0;
        yOffset += screenHeight;
      }
    }
    // }
    // await saveScenesToLocal();
  }

  saveScenesToLocal() async {
    await LocalData().saveJsonMaps(scenes);
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
