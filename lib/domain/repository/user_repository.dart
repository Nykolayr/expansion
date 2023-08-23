import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/data/base_data.dart';
import 'package:expansion/data/local_data.dart';
import 'package:expansion/domain/models/game/game.dart';
import 'package:expansion/domain/models/setting/settings.dart';
import 'package:expansion/domain/models/upgrade.dart';
import 'package:expansion/domain/models/user/user.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  UserGame user = UserGame.init();
  Settings settings = const Settings();
  Game game = const Game();

  AllUpgrade upEnemy = AllUpgrade.initialEnemy();
  AllUpgrade upOur = AllUpgrade.initialOur();

  static UserRepository? _instance;

  static Future<UserRepository> getInstance() async {
    _instance ??= await create();
    return _instance!;
  }

  UserRepository._();

  static Future<UserRepository> create() async {
    late UserRepository userRepository;

    String? data = await LocalData().loadJsonUser();

    if (data != '{}' && data != '') {
      userRepository = UserRepository.fromJson(jsonDecode(data!));
    } else {
      List<String> locale = Platform.localeName.split('_');
      userRepository = UserRepository._();
      switch (locale[0]) {
        case 'ru':
          userRepository.settings = userRepository.settings.copyWith(
            lang: Lang.ru,
          );
          break;
        case 'en':
          userRepository.settings = userRepository.settings.copyWith(
            lang: Lang.en,
          );
          break;
      }
      userRepository.saveUser();
    }

    return userRepository;
  }

  Future loadFromBase(String id) async {
    Map<String, dynamic> data = await BaseData().loadJson(id: id);
    _instance = UserRepository.fromJson(data);
  }

  UserRepository.fromJson(Map<String, dynamic> json)
      : user = UserGame.fromJson(json['user']),
        settings = Settings.fromJson(json['settings']),
        game = Game.fromJson(json['game']),
        upEnemy = AllUpgrade.fromJson(json['upEnemy']),
        upOur = AllUpgrade.fromJson(json['upOur']);

  Map<String, dynamic> toJson() => {
        'user': user,
        'settings': settings,
        'game': game,
        'upEnemy': upEnemy,
        'upOur': upOur,
      };

  setScore(int score) {
    upOur.allScore += score;
    upOur.score += score;
    user = user.copyWith(score: upOur.allScore);
    upEnemy.toAllUpgrade();
    saveUser();
  }

  initUser() {
    user = UserGame.init();
    user = user.copyWith(name: tr('guest'));
    settings = const Settings();
    game = const Game();
    game = game.copyWith(isSplash: false);
    upEnemy = AllUpgrade.initialEnemy();
    upOur = AllUpgrade.initialOur();
    saveUser();
  }

  Future<void> saveUser() async {
    if (user.isRegistration) {
      await BaseData().saveJson(json: toJson(), user: user);
    }
    await LocalData().saveJsonUser(toJson());
  }

  setLang(Lang lang) {
    settings = settings.copyWith(lang: lang);
    saveUser();
  }

  setLevel(Level level) {
    game = game.copyWith(level: level);
    saveUser();
  }

  setUniver(Univer univer) {
    game = game.copyWith(univer: univer);
    saveUser();
  }
}
