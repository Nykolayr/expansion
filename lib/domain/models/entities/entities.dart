import 'dart:math';

import 'package:expansion/utils/colors.dart';
import 'package:flutter/material.dart';

abstract class EntitesObject {
  Point coordinates; // координаты базы
  TypeStatus typeStatus; // статус базы enum TypeStatus {our, enemy, neutral}
  int ships; // количество кораблей на базе
  double size;

  EntitesObject({
    required this.coordinates,
    required this.typeStatus,
    required this.ships,
    required this.size,
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

  String get shipImage {
    switch (this) {
      case TypeStatus.our:
        return 'assets/svg/our_ship.svg';
      case TypeStatus.enemy:
        return 'assets/svg/enemy_ship.svg';
      case TypeStatus.neutral:
        return 'assets/svg/enemy_ship.svg';
    }
  }

  BoxDecoration get boxDecor {
    switch (this) {
      case TypeStatus.our:
        return AppColor.ourPlanet;
      case TypeStatus.enemy:
        return AppColor.enemyPlanet;
      case TypeStatus.neutral:
        return AppColor.neutralPlanet;
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
