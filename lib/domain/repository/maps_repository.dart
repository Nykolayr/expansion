import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion/api/api.dart';
import 'package:expansion/data/base_data.dart';
import 'package:expansion/data/local_data.dart';
import 'package:expansion/domain/models/maps/scenes.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:surf_logger/surf_logger.dart';

/// репозитарий для управления игровыми сценами и картами для битвы

class MapsRepository extends GetxController {
  List<Scene> scenes = [];

  MapsRepository._privateConstructor();
  static final MapsRepository _instance = MapsRepository._privateConstructor();

  factory MapsRepository() {
    return _instance;
  }

  Future<void> init() async {
    scenes = await BaseData().loadScenesJson();
    return;
    // scenes =
    //     querySnapshot.docs.map((doc) => Scene.fromJson(doc.data())).toList();

    final data = await LocalData().loadJsonMaps();
    var listJson = [];
    if (data.isNotEmpty) {
      listJson = jsonDecode(data) as List<dynamic>;
      scenes = List<Scene>.from(
          listJson.map((x) => Scene.fromJson(x as Map<String, dynamic>)));
    } else {
      listJson = await Api.loadJsonScenes();
      final temp = List<Scene>.from(
          listJson.map((x) => Scene.fromJson(x as Map<String, dynamic>)));
      // при первой загрузкеы переделываем все сцены по 5 штук змейкой
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
  }
}
