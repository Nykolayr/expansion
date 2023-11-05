import 'package:expansion/domain/models/entities/base.dart';
import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/repository/game_repository.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/ui/widgets/widgets.dart';
import 'package:get/get.dart';

Future<void> setStateEnemy(BattleBloc block) async {
  final bases = Get.find<GameRepository>().bases;
  final basesNeutral = <Base>[];
  final basesEnemy = <Base>[];
  final basesOur = <Base>[];
  final basesFromAttack = <Base>[];
  final basesToAttack = <Base>[];
  final basesFromSuppot = <Base>[];
  final basesToSuppot = <Base>[];

  //отправка кораблей
  void sendShips(List<int> list, int toIndex) {
    for (final index in list) {
      block.add(SendEvent(toIndex, index));
    }
  }

// проверка baз, которые смогут отправить корабли для захвата
  List<int> isAttacCheck(Base enemyBase) {
    final attackBaseIndex = <int>[];
    final forceEnemy = enemyBase.ships + enemyBase.shild + 5;
    var forceOur = 0;
    for (var k = 0; k < basesFromAttack.length; k++) {
      if (getBase(basesFromAttack[k].coordinates, enemyBase.coordinates) ==
          null) {
        attackBaseIndex.add(basesFromAttack[k].index);
        forceOur += basesFromAttack[k].ships;
        if (forceOur > forceEnemy) return attackBaseIndex;
      }
    }

    return [];
  }

// Предварительная сортировка на своих, чужих и нейтральных
// и их сортировка по ships от меньших к большим
  void preparation() {
    basesNeutral.clear();
    basesEnemy.clear();
    basesOur.clear();
    for (final base in bases) {
      switch (base.typeStatus) {
        case TypeStatus.enemy:
          basesOur.add(base);
        case TypeStatus.our:
          basesEnemy.add(base);
        case TypeStatus.neutral:
          basesNeutral.add(base);
        case TypeStatus.asteroid:
      }
    }
    sortBaseShips(basesNeutral);
    sortBaseShips(basesEnemy);
    sortBaseShips(basesOur);
  }

// заполнение basesFromAttack, basesToAttack перед атакой
  void fillingAttack(List<Base> basesEnemy) {
    for (final baseE in basesEnemy) {
      for (final baseO in basesOur) {
        if (getBase(baseE.coordinates, baseO.coordinates) == null) {
          if (!basesFromAttack.contains(baseO)) basesFromAttack.add(baseO);
          if (!basesToAttack.contains(baseE)) basesToAttack.add(baseE);
        }
      }
    }
    sortBaseShips(basesFromAttack);
    sortBaseShips(basesToAttack);
  }

  // заполнение basesFromAttack, basesToAttack для поддержки баз
  void fillingSupport() {
    for (final baseE in basesOur) {
      for (final baseO in basesOur) {
        if (getBase(baseE.coordinates, baseO.coordinates) == null) {
          if (!basesFromSuppot.contains(baseO) && baseO.ships > 50) {
            basesFromSuppot.add(baseO);
          }
          if (!basesToSuppot.contains(baseE) && baseO.ships < 10) {
            basesToSuppot.add(baseE);
          }
        }
      }
    }
    sortBaseShips(basesFromSuppot);
    sortBaseShips(basesToSuppot);
  }

// основное тело функции AI врага
  // проверяем апы и если хватает ресурсов поднимаем щит и скорость постройки кораблей
  preparation();
  for (final base in basesOur) {
    if (getIsUpShild(base)) base.upShild();
    if (getIsUpSpeed(base)) base.upSpeedBuild();
  }
  basesNeutral.isNotEmpty
      ? fillingAttack(basesNeutral)
      : fillingAttack(basesEnemy);
  var listOur = <int>[];
  for (final baseE in basesToAttack) {
    listOur = isAttacCheck(baseE);
    if (listOur.isNotEmpty) {
      sendShips(listOur, baseE.index);
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
  await Future.delayed(const Duration(milliseconds: 200));
  fillingSupport();

  for (final baseTo in basesToSuppot) {
    for (final baseFrom in basesFromSuppot) {
      if (getBase(baseTo.coordinates, baseFrom.coordinates) == null &&
          baseFrom.ships > 50 &&
          baseTo.ships < 20) {
        sendShips([baseFrom.index], baseTo.index);
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }
  }
}

void sortBaseShips(List<Base> bases) {
  bases.sort((a, b) => (a.ships + a.shild).compareTo(b.ships + b.shild));
}
