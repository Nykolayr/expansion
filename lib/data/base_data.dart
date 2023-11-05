// ignore_for_file: avoid_print

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:expansion/domain/models/maps/scenes.dart';
import 'package:expansion/domain/models/user/user.dart';
import 'package:expansion/utils/value.dart';
import 'package:get/get.dart';
import 'package:surf_logger/surf_logger.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

///сохранение и загрузка в базе данных на сервере
class BaseData {
  final dio = Dio();
  void configureDio() {
    // Set default configs
    dio.options.baseUrl = Values.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 3);

    dio.interceptors.add(
      TalkerDioLogger(
        talker: Get.find<Talker>(),
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: true,
          printResponseHeaders: true,
        ),
      ),
    );
  }

  Future<List<UserGame>> loadAllUsers() async {
    try {
      Logger.d('msg >>>>>1');
      final response = await dio.get('/expansion/load_all_uers');
      Logger.d('msg >>>>>2  ${response.data}');
      List<UserGame> users = [];
      return users;
    } on DioException catch (e) {
      Logger.e('ошибка при загрузке всех юзеров == $e');
      return [];
    }
  }

  Future<List<Scene>> loadScenesBase() async {
    try {
      return [];
    } on DioException catch (e) {
      Logger.e('ошибка при загрузке сцен == ${e.message}');
      return [];
    }
  }

  Future<void> saveUserJson(
      {required Map<String, dynamic> json, required UserGame user}) async {}

  Future<Map<String, dynamic>> loadUserJson({required String id}) async {
    return {};
  }
}
