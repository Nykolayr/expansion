import 'dart:math';

import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';

/// абстрактный объект ля всех объектов в битве
abstract class EntitesObject {
  Point coordinates; // координаты объекта
  TypeStatus typeStatus; // статус базы enum TypeStatus {our, enemy, neutral}
  int ships; // количество кораблей на базе
  int index; // случайное число, для индетификации
  double size;

  EntitesObject({
    required this.coordinates,
    required this.typeStatus,
    required this.ships,
    required this.size,
    required this.index,
  });

  void update() {}

  Widget build({
    required int index,
    required BuildContext context,
    Function(int sender) onAccept,
  });
}

enum TypeStatus {
  our,
  enemy,
  neutral,
  asteroid;

  double get minShild {
    switch (this) {
      case TypeStatus.our:
        return userRepository.upOur.minShild;
      case TypeStatus.enemy:
        return userRepository.upEnemy.minShild;
      case TypeStatus.neutral:
        return 0;
      case TypeStatus.asteroid:
        return 0;
    }
  }

  double get shipSpeed {
    switch (this) {
      case TypeStatus.our:
        return userRepository.upOur.shipSpeed();
      case TypeStatus.enemy:
        return userRepository.upEnemy.shipSpeed();
      case TypeStatus.neutral:
        return 1;
      case TypeStatus.asteroid:
        return 0;
    }
  }

  double get shipDurability {
    switch (this) {
      case TypeStatus.our:
        return userRepository.upOur.shipDurability();
      case TypeStatus.enemy:
        return userRepository.upEnemy.shipDurability();
      case TypeStatus.neutral:
        return 1;
      case TypeStatus.asteroid:
        return 0;
    }
  }

  double get shieldDurability {
    switch (this) {
      case TypeStatus.our:
        return userRepository.upOur.shieldDurability();
      case TypeStatus.enemy:
        return userRepository.upEnemy.shieldDurability();
      case TypeStatus.neutral:
        return 1;
      case TypeStatus.asteroid:
        return 0;
    }
  }

  double get speedBuildShip {
    switch (this) {
      case TypeStatus.our:
        return userRepository.upOur.shipBuildSpeed();
      case TypeStatus.enemy:
        return userRepository.upEnemy.shipBuildSpeed();
      case TypeStatus.neutral:
        return 0;
      case TypeStatus.asteroid:
        return 0;
    }
  }

  double get speedResources {
    switch (this) {
      case TypeStatus.our:
        return userRepository.upOur.resourceIncomeSpeed();
      case TypeStatus.enemy:
        return userRepository.upEnemy.resourceIncomeSpeed();
      case TypeStatus.neutral:
        return 0;
      case TypeStatus.asteroid:
        return 0;
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
      case TypeStatus.asteroid:
        return '';
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
      case TypeStatus.asteroid:
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
      case TypeStatus.asteroid:
        return AppColor.red;
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
      case TypeStatus.asteroid:
        return AppColor.white;
    }
  }
}
