import 'dart:convert';
import 'dart:io';
import 'package:expansion/data/local_data.dart';
import 'package:expansion/domain/models/user/setting/settings.dart';
import 'package:expansion/domain/models/user/user.dart';

class UserRepository {
  User user = const User(
    name: 'Гость',
  );
  Settings settings = const Settings();
  UserRepository._();

  static Future<UserRepository> create() async {
    late UserRepository userRepository;
    String? data = await LocalData().loadJson();
    print('object - $data');
    if (data != '{}' && data != '') {
      userRepository = UserRepository.fromJson(jsonDecode(data!));
    } else {
      List<String> locale = Platform.localeName.split('_');
      userRepository = UserRepository._();
      switch (locale[0]) {
        case 'ru':
          userRepository.settings.copyWith(
            lang: Lang.ru,
          );
          break;
        case 'en':
          userRepository.settings.copyWith(
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
        settings = Settings.fromJson(json['settings']);

  Map<String, dynamic> toJson() => {
        'user': user,
        'settings': settings,
      };

  saveUser() {
    LocalData().saveJson(toJson());
  }
}
