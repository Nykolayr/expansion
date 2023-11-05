import 'dart:async';
import 'package:surf_logger/surf_logger.dart';

enum GRUDType {
  scenes,
  ret,
  user;
}

enum CRUDOperation {
  add,
  all,
  create,
  read,
  update,
  delete;

  Future<dynamic> setGRUD({
    required GRUDType type,
    String? document,
    Map<String, dynamic> json = const {},
  }) async {
    switch (this) {
      case CRUDOperation.add:
        {}
      case CRUDOperation.all:
        {}
      case CRUDOperation.create:
        {}
      case CRUDOperation.read:
        {}
      case CRUDOperation.update:
        {}
      case CRUDOperation.delete:
        {}
    }
  }
}
