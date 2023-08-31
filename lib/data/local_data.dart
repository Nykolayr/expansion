import 'dart:convert';

import 'package:expansion/domain/models/maps/scenes.dart';
import 'package:shared_preferences/shared_preferences.dart';

///сохранение и загрузка в shared_preferences
class LocalData {
  Future<void> saveJsonUser(Map<String, dynamic> json,
      [String key = 'user']) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(json));
  }

  Future<String?> loadJsonUser([String key = 'user']) async {
    final prefs = await SharedPreferences.getInstance();
    final setKeys = prefs.getKeys();
    if (setKeys.contains(key)) {
      return prefs.getString(key);
    } else {
      await saveJsonUser({}, key);
      return '';
    }
  }

  Future<void> saveJsonMaps(List<Scene> scenes, [String key = 'maps']) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(scenes));
  }

  Future<String?> loadJsonMaps([String key = 'maps']) async {
    final prefs = await SharedPreferences.getInstance();
    final setKeys = prefs.getKeys();
    if (setKeys.contains(key)) {
      return prefs.getString(key);
    } else {
      await saveJsonUser({}, key);
      return '';
    }
  }
}
