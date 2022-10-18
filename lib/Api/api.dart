import 'dart:convert';

import 'package:expansion/utils/value.dart';
import 'package:flutter/services.dart';

class Api {
  static Future<Map<String, dynamic>> loadJson(int countScene) async {
    String data = await rootBundle
        .loadString('$pathAssetScenes/objects_$countScene.json');
    return json.decode(data);
  }
}
