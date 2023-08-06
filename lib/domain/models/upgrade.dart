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
        nextScore: scoreMultiplier,
        nextValue: 5,
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
        nextValue: 20,
        type: TypeUp.beginShips,
        value: 100));
    list.add(Upgrade.from(TypeUp.tic, 5)); // скорость отклика врага
    return AllUpgrade(list: list, score: 0, allScore: 0);
  }

  double getFromType(TypeUp type) {
    return list.firstWhere((element) => element.type == type).value;
  }

  double shipSpeed() {
    return list[0].value;
  }

  double shipDurability() {
    return list[1].value;
  }

  double shipBuildSpeed() {
    return list[2].value;
  }

  double resourceIncomeSpeed() {
    return list[3].value;
  }

  double shieldDurability() {
    return list[4].value;
  }

  int beginShips() {
    return list[5].value.round();
  }

  double tic() {
    return list[6].value;
  }

  addScore(int inScore) {
    allScore += inScore;
    score += inScore;
  }

  // Метод для апгрейда параметра
  toUpgrade(int index) {
    Upgrade upgrade = list[index];
    upgrade.level++;
    upgrade.value += 1 / upgrade.nextValue;
    upgrade.nextScore *= 2;
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
        return 'assets/svg/help.svg';
      case TypeUp.shipDurability:
        return 'assets/svg/help.svg';
      case TypeUp.shipBuildSpeed:
        return 'assets/svg/help.svg';
      case TypeUp.resourceIncomeSpeed:
        return 'assets/svg/help.svg';
      case TypeUp.shieldDurability:
        return 'assets/svg/help.svg';
      case TypeUp.beginShips:
        return 'assets/svg/help.svg';
      case TypeUp.tic:
        return 'assets/svg/help.svg';
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
  double value; // начальное значение
  int level; // начальный уровень
  int nextValue; // процент на который идет прирост с последующим уровнем
  int nextScore; // начальный уровень очков для перехода на новый уровень
  Upgrade({
    required this.type,
    required this.value,
    required this.level,
    required this.nextValue,
    required this.nextScore,
  });
  factory Upgrade.from(TypeUp type, int nextValue) {
    return Upgrade(
        type: type,
        value: 1,
        level: 0,
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
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type.index,
        'value': value,
        'level': level,
        'nextValue': nextValue,
        'nextScore': nextScore,
      };
}
