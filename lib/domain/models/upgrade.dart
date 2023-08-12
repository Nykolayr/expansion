import 'package:easy_localization/easy_localization.dart';
import 'package:expansion/utils/value.dart';

/// класс для отлеживания очков и апгрейда
/// различных параметров игрока
class AllUpgrade {
  final int maxLevel = 5; // максимальный уровень апгрейда
  int score; // Начальное количество очков
  int allScore; // Общее количество очков
  double minShild = 20; // минимальный ап щита
  List<Upgrade> list = [];

  AllUpgrade({required this.score, required this.allScore, required this.list});
  factory AllUpgrade.fromJson(Map<String, dynamic> json) {
    return AllUpgrade(
        score: json['score'],
        allScore: json['allScore'],
        list: List.from(json['list']).map((x) => Upgrade.fromJson(x)).toList());
  }
  factory AllUpgrade.initialOur() {
    List<Upgrade> list = [];
    list.add(Upgrade.from(TypeUp.shipSpeed, 10)); // скорость кораблей
    list.add(Upgrade.from(TypeUp.shipDurability, 5)); // прочность кораблей
    list.add(
        Upgrade.from(TypeUp.shipBuildSpeed, 10)); // скорость прироста кораблей
    list.add(Upgrade.from(
        TypeUp.resourceIncomeSpeed, 10)); // скорость прироста ресурсов
    list.add(Upgrade.from(TypeUp.shieldDurability, 15)); // прочность щита
    // Начальное значение кораблей на базе в начале игры
    list.add(Upgrade(
        level: 0,
        percenstValue: 0,
        nextScore: scoreMultiplier,
        nextValue: 10,
        type: TypeUp.beginShips,
        value: 100));
    return AllUpgrade(list: list, score: 0, allScore: 0);
  }

  /// иницилизируем систему upgrade  в начале игры
  factory AllUpgrade.initialEnemy() {
    List<Upgrade> list = [];
    list.add(Upgrade.from(TypeUp.shipSpeed, 5)); // скорость кораблей
    list.add(Upgrade.from(TypeUp.shipDurability, 5)); // прочность кораблей
    list.add(
        Upgrade.from(TypeUp.shipBuildSpeed, 5)); // скорость прироста кораблей
    list.add(Upgrade.from(
        TypeUp.resourceIncomeSpeed, 5)); // скорость прироста ресурсов
    list.add(Upgrade.from(TypeUp.shieldDurability, 5)); // прочность щита
    // Начальное значение кораблей на базе в начале игры
    list.add(Upgrade(
        level: 0,
        nextScore: scoreMultiplier,
        nextValue: 10,
        percenstValue: 0,
        type: TypeUp.beginShips,
        value: 100));
    list.add(Upgrade.from(TypeUp.tic, 5)); // скорость отклика врага
    return AllUpgrade(list: list, score: 0, allScore: 0);
  }

  double getFromType(TypeUp type) {
    return list.firstWhere((element) => element.type == type).value;
  }

  double shipSpeed() {
    return (list[0].value * (1 + list[0].percenstValue / 100));
  }

  double shipDurability() {
    return (list[1].value * (1 + list[1].percenstValue / 100));
  }

  double shipBuildSpeed() {
    return (list[2].value * (1 + list[2].percenstValue / 100));
  }

  double resourceIncomeSpeed() {
    return (list[3].value * (1 + list[3].percenstValue / 100));
  }

  double shieldDurability() {
    return (list[4].value * (1 + list[4].percenstValue / 100));
  }

  int beginShips() {
    return (list[5].value * (1 + list[5].percenstValue / 100)).round();
  }

  double tic() {
    return (list[6].value * (1 + list[6].percenstValue / 100));
  }

  // Метод для апгрейда параметра
  toUpgrade(TypeUp type) {
    int index = list.indexWhere((element) => element.type == type);
    Upgrade upgrade = list[index];
    upgrade.level++;
    upgrade.percenstValue += upgrade.nextValue;
    score -= upgrade.nextScore;
    upgrade.nextScore *= 2;
  }

  bool isUpgrade(Upgrade upgrade) {
    return upgrade.nextScore < score;
  }

  Upgrade getUpgradeFromType(TypeUp type) {
    return list.firstWhere((element) => element.type == type);
  }

  Map<String, dynamic> toJson() => {
        'score': score,
        'allScore': allScore,
        'list': list,
      };
}

enum TypeUp {
  shipSpeed,
  shipDurability,
  shipBuildSpeed,
  resourceIncomeSpeed,
  shieldDurability,
  beginShips,
  tic;

  String get text {
    switch (this) {
      case TypeUp.shipSpeed:
        return tr(name);
      case TypeUp.shipDurability:
        return tr(name);
      case TypeUp.shipBuildSpeed:
        return tr(name);
      case TypeUp.resourceIncomeSpeed:
        return tr(name);
      case TypeUp.shieldDurability:
        return tr(name);
      case TypeUp.beginShips:
        return tr(name);
      case TypeUp.tic:
        return tr(name);
    }
  }

  String get image {
    switch (this) {
      case TypeUp.shipSpeed:
        return 'assets/svg/rocket.svg';
      case TypeUp.shipDurability:
        return 'assets/svg/shield.svg';
      case TypeUp.shipBuildSpeed:
        return 'assets/svg/rocket.svg';
      case TypeUp.resourceIncomeSpeed:
        return 'assets/svg/hammers.svg';
      case TypeUp.shieldDurability:
        return 'assets/svg/shield.svg';
      case TypeUp.beginShips:
        return 'assets/svg/rocket.svg';
      case TypeUp.tic:
        return 'assets/svg/ship.svg';
    }
  }

  String get textHelp {
    switch (this) {
      case TypeUp.shipSpeed:
        return tr('${name}_help');
      case TypeUp.shipDurability:
        return tr('${name}_help');
      case TypeUp.shipBuildSpeed:
        return tr('${name}_help');
      case TypeUp.resourceIncomeSpeed:
        return tr('${name}_help');
      case TypeUp.shieldDurability:
        return tr('${name}_help');
      case TypeUp.tic:
        return tr('${name}_help');
      case TypeUp.beginShips:
        return tr('${name}_help');
    }
  }
}

class Upgrade {
  TypeUp type; // тип апгрейда
  double value; // начальное значение в процентах
  int level; // начальный уровень
  int nextValue; // процент на который идет прирост с последующим уровнем
  int percenstValue; // текущий процент
  int nextScore; // начальный уровень очков для перехода на новый уровень
  Upgrade({
    required this.type,
    required this.value,
    required this.level,
    required this.nextValue,
    required this.nextScore,
    required this.percenstValue,
  });
  factory Upgrade.from(TypeUp type, int nextValue) {
    return Upgrade(
        type: type,
        value: 1,
        level: 0,
        percenstValue: 0,
        nextValue: nextValue,
        nextScore: scoreMultiplier);
  }

  factory Upgrade.fromJson(Map<String, dynamic> json) {
    return Upgrade(
      type: TypeUp.values[json['type']],
      value: json['value'],
      level: json['level'],
      nextValue: json['nextValue'],
      nextScore: json['nextScore'],
      percenstValue: json['percenstValue'],
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.index,
        'value': value,
        'level': level,
        'nextValue': nextValue,
        'nextScore': nextScore,
        'percenstValue': percenstValue,
      };
}
