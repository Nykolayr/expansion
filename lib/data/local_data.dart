import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalData {
  Future<void> saveJson(Map<String, dynamic> json,
      [String key = 'user']) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(json));
  }

  Future<String?> loadJson([String key = 'user']) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> setKeys = prefs.getKeys();
    if (setKeys.contains(key)) {
      return prefs.getString(key);
    } else {
      await saveJson({}, key);
      return '';
    }
  }
}
