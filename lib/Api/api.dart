import 'dart:convert';

import 'package:expansion/utils/value.dart';
import 'package:flutter/services.dart';

class Api {
  static Future<Map<String, dynamic>> loadJsonBase(int countScene) async {
    String data = await rootBundle
        .loadString('$pathAssetScenes/objects_$countScene.json');
    return json.decode(data);
  }

  static Future<List<dynamic>> loadJsonScenes() async {
    String data = await rootBundle.loadString('$pathAssetScenes/scenes.json');

    return json.decode(data);
  }
}
