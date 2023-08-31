// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion/domain/models/user/user.dart';
import 'package:expansion/domain/repository/user_repository.dart';
import 'package:get/get.dart';

///сохранение и загрузка в базе данных гугла
class BaseData {
  Future<void> saveJson(
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

  Future<Map<String, dynamic>> loadJson({required String id}) async {
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
