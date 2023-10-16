// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion/domain/models/maps/scenes.dart';
import 'package:expansion/domain/models/user/user.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:get/get.dart';
import 'package:surf_logger/surf_logger.dart';

///сохранение и загрузка в базе данных гугла
class BaseData {
  Future<List<Scene>> loadScenesJson() async {
    const path = 'scenes';
    final CollectionReference scenesRef =
        FirebaseFirestore.instance.collection(path);
    await scenesRef.get().then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Коллекция 'scenes' существует и не пуста.
        Logger.d("Коллекция '$path' существует.");
      } else {
        // Коллекция 'scenes' пуста или не существует.
        Logger.e("Коллекция '$path' пуста или не существует.");
      }
    }).onError((error, stackTrace) {
      Logger.e('Error: >>>>>>>>>>>>>>>>> $error');
    });
    final CollectionReference scenes =
        FirebaseFirestore.instance.collection('scenes');
    final querySnapshot = await scenes.get();
    Logger.d('scenesRef ${scenes.count()}');
    if (querySnapshot.docs.isNotEmpty) {
      final documents = querySnapshot.docs;
      for (final doc in documents) {
        Logger.d('Document ID: ${doc.id}');
        Logger.d('Data: ${doc.data()}');
      }
    } else {
      Logger.d('No documents found.');
    }
    return [];
  }

  Future<void> saveScenesJson() async {
    final CollectionReference scenes =
        FirebaseFirestore.instance.collection('scenes');
  }

  Future<void> saveUserJson(
      {required Map<String, dynamic> json, required UserGame user}) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    return users
        .doc(user.id)
        .set({
          'id': user.id,
          'json': jsonEncode(json),
          'score': user.score,
        })
        .then((value) => print('User Added'))
        .catchError((error) => print('Failed to add user: $error'));
  }

  Future<Map<String, dynamic>> loadUserJson({required String id}) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    var docSnapshot = await users.doc(id).get();
    var data = <String, dynamic>{};
    if (docSnapshot.data() == null) {
      await Get.find<UserRepository>().saveUser();
      docSnapshot = await users.doc(id).get();
    }
    if (docSnapshot.data() == null) {
      data = docSnapshot.data()! as Map<String, dynamic>;
      return jsonDecode(data['json'] as String) as Map<String, dynamic>;
    } else {
      return {};
    }
  }
}
