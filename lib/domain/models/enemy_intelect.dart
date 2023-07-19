import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/ui/widgets/widgets.dart';
// import 'package:expansion/domain/models/entities/ships.dart';
import 'package:expansion/utils/value.dart';

void setStateEnemy(BattleBloc block) async {
  List<BaseObject> bases = gameRepository.gameData.bases;
  List<BaseObject> basesNeutral = [];
  List<BaseObject> basesEnemy = [];
  List<BaseObject> basesOur = [];
  List<BaseObject> basesFromAttack = [];
  List<BaseObject> basesToAttack = [];
  List<BaseObject> basesFromSuppot = [];
  List<BaseObject> basesToSuppot = [];

  //отправка кораблей
  sendShips(List<int> list, int toIndex) {
    for (int index in list) {
      block.add(SendEvent(toIndex, index));
    }
  }

// проверка baз, которые смогут отправить корабли для захвата
  List<int> isAttacCheck(BaseObject enemyBase) {
    List<int> attackBaseIndex = [];
    double forceEnemy = enemyBase.ships + enemyBase.shild + 5;
    double forceOur = 0;
    for (int k = 0; k < basesFromAttack.length; k++) {
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
  preparation() {
    basesNeutral.clear();
    basesEnemy.clear();
    basesOur.clear();
    for (BaseObject base in bases) {
      switch (base.typeStatus) {
        case TypeStatus.enemy:
          basesOur.add(base);
          break;
        case TypeStatus.our:
          basesEnemy.add(base);
          break;
        case TypeStatus.neutral:
          basesNeutral.add(base);
          break;
        case TypeStatus.asteroid:
      }
    }
    sortBaseShips(basesNeutral);
    sortBaseShips(basesEnemy);
    sortBaseShips(basesOur);
  }

// заполнение basesFromAttack, basesToAttack перед атакой
  fillingAttack(List<BaseObject> basesEnemy) {
    for (var baseE in basesEnemy) {
      for (var baseO in basesOur) {
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
  fillingSupport() {
    for (var baseE in basesOur) {
      for (var baseO in basesOur) {
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
  for (BaseObject base in basesOur) {
    if (getIsUpShild(base)) base.upShild();
    if (getIsUpSpeed(base)) base.upSpeedBuild();
  }
  basesNeutral.isNotEmpty
      ? fillingAttack(basesNeutral)
      : fillingAttack(basesEnemy);
  List<int> listOur = [];
  for (BaseObject baseE in basesToAttack) {
    listOur = isAttacCheck(baseE);
    if (listOur.isNotEmpty) {
      sendShips(listOur, baseE.index);
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }
  await Future.delayed(const Duration(milliseconds: 200));
  fillingSupport();

  for (var baseTo in basesToSuppot) {
    for (var baseFrom in basesFromSuppot) {
      if (getBase(baseTo.coordinates, baseFrom.coordinates) == null &&
          baseFrom.ships > 50 &&
          baseTo.ships < 20) {
        sendShips([baseFrom.index], baseTo.index);
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }
  }
}

sortBaseShips(List<BaseObject> bases) {
  bases.sort((a, b) => (a.ships + a.shild).compareTo(b.ships + b.shild));
}
