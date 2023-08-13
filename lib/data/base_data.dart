// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion/domain/models/user/user.dart';

class BaseData {
  Future<void> saveJson(
      {required Map<String, dynamic> json, required UserGame user}) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users
        .doc(user.id)
        .set({
          'id': user.id,
          'json': jsonEncode(json),
          'score': user.score,
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<String?> loadJson({required String id}) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await users.doc(id).get();
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    print('docSnapshot == ${docSnapshot.data().runtimeType}');
    return data['json'];
  }
}
