import 'package:easy_localization/easy_localization.dart';

/// класс для отлеживания очков и апгрейда
/// различных параметров игрока
class AllUpgrade {
  final int maxLevel = 5; // максимальный уровень апгрейда
  int score; // Начальное количество очков
  double minShild = 20; // минимальный ап щита
  List<Upgrade> list = [];

  AllUpgrade({required this.score, required this.list});
  factory AllUpgrade.fromJson(Map<String, dynamic> json) {
    return AllUpgrade(
        score: json['score'],
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
    return AllUpgrade(list: list, score: 0);
  }
  factory AllUpgrade.initialEnemy() {
    List<Upgrade> list = [];
    list.add(Upgrade.from(TypeUp.shipSpeed, 5)); // скорость кораблей
    list.add(Upgrade.from(TypeUp.shipDurability, 5)); // прочность кораблей
    list.add(
        Upgrade.from(TypeUp.shipBuildSpeed, 5)); // скорость прироста кораблей
    list.add(Upgrade.from(
        TypeUp.resourceIncomeSpeed, 5)); // скорость прироста ресурсов
    list.add(Upgrade.from(TypeUp.shieldDurability, 5)); // прочность щита
    list.add(Upgrade.from(TypeUp.tic, 5)); // скорость отклика врага
    return AllUpgrade(list: list, score: 0);
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

  double tic() {
    return list[5].value;
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
        'list': list,
      };
}

enum TypeUp {
  shipSpeed,
  shipDurability,
  shipBuildSpeed,
  resourceIncomeSpeed,
  shieldDurability,
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
      case TypeUp.tic:
        return tr(name);
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
    }
  }
}

class Upgrade {
  TypeUp type;
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
        type: type, value: 1, level: 0, nextValue: nextValue, nextScore: 500);
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
