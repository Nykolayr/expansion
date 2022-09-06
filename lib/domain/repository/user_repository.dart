import 'dart:convert';
import 'package:expansion/data/local_data.dart';
import 'package:expansion/domain/models/user/user.dart';

class UserRepository {
  User user = const User(
    name: 'Гость',
  );

  UserRepository._();

  static Future<UserRepository> create() async {
    late UserRepository userRepository;
    String? data = await LocalData().loadJson();
    if (data != '{}' && data != '') {
      userRepository = UserRepository.fromJson(jsonDecode(data!)['user']);
    } else {
      userRepository = UserRepository._();
      userRepository.saveUser();
    }
    return userRepository;
  }

  UserRepository.fromJson(Map<String, dynamic> json)
      : user = User.fromJson(json);

  Map<String, dynamic> toJson() => {
        'user': user,
      };

  saveUser() {
    LocalData().saveJson(toJson());
  }
}
