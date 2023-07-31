import 'dart:convert';
import 'dart:io';
import 'package:expansion/data/local_data.dart';
import 'package:expansion/domain/models/game/game.dart';
import 'package:expansion/domain/models/setting/settings.dart';
import 'package:expansion/domain/models/upgrade.dart';
import 'package:expansion/domain/models/user/user.dart';

class UserRepository {
  User user = const User(
    name: 'Гость',
  );
  Settings settings = const Settings();
  Game game = const Game();
  AllUpgrade upEnemy = AllUpgrade.initialEnemy();
  AllUpgrade upOur = AllUpgrade.initialOur();
  UserRepository._();

  static Future<UserRepository> create() async {
    late UserRepository userRepository;
    String? data = await LocalData().loadJson();
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

  UserRepository.fromJson(Map<String, dynamic> json)
      : user = User.fromJson(json['user']),
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

  saveUser() {
    LocalData().saveJson(toJson());
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
