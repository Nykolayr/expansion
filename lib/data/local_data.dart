import 'package:expansion/domain/models/maps/scenes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

///сохранение и загрузка в shared_preferences
class LocalData {
  Future<void> saveJsonUser(Map<String, dynamic> json,
      [String key = 'user']) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(json));
  }

  Future<String?> loadJsonUser([String key = 'user']) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> setKeys = prefs.getKeys();
    if (setKeys.contains(key)) {
      return prefs.getString(key);
    } else {
      await saveJsonUser({}, key);
      return '';
    }
  }

  Future<void> saveJsonMaps(List<Scene> json, [String key = 'maps']) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(json));
  }

  Future<String?> loadJsonMaps([String key = 'maps']) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> setKeys = prefs.getKeys();
    if (setKeys.contains(key)) {
      return prefs.getString(key);
    } else {
      await saveJsonUser({}, key);
      return '';
    }
  }
}


