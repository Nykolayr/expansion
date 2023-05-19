import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';

abstract class EntitesObject {
  Size coordinates;
  TypeStatus typeStatus;
  int ships;

  EntitesObject({
    required this.coordinates,
    required this.typeStatus,
    required this.ships,
  });

  void update();
  Widget build({
    required int index,
    required BuildContext context,
    Function() click,
    Function(int sender) onAccept,
  });
}

enum TypeStatus {
  our,
  enemy,
  neutral;

  String get desc {
    switch (this) {
      case TypeStatus.our:
        return 'Этот объект наш';
      case TypeStatus.enemy:
        return 'Этот объект вражеский';
      case TypeStatus.neutral:
        return 'Этот объект нейтральный';
    }
  }

  Color get color {
    switch (this) {
      case TypeStatus.our:
        return AppColor.green;
      case TypeStatus.enemy:
        return AppColor.red;
      case TypeStatus.neutral:
        return AppColor.white;
    }
  }

  Color get colorText {
    switch (this) {
      case TypeStatus.our:
        return AppColor.white;
      case TypeStatus.enemy:
        return AppColor.white;
      case TypeStatus.neutral:
        return AppColor.black;
    }
  }
}
