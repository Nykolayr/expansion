import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
import 'package:expansion/ui/widgets/widgets.dart';
// import 'package:expansion/domain/models/entities/ships.dart';
import 'package:expansion/utils/value.dart';

void setStateEnemy(BattleBloc block) async {
  List<BaseObject> bases = gameRepository.gameData.bases;
  // List<Ship> ships = gameRepository.gameData.ships;

  List<BaseObject> basesNeutral = [];
  List<BaseObject> basesEnemy = [];
  List<BaseObject> basesOur = [];
  sort() {
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

  sort();
  // проверяем апы и если хватает ресурсов поднимаем щит и скорость постройки кораблей
  for (BaseObject base in basesOur) {
    if (getIsUpShild(base)) base.upShild();
    if (getIsUpSpeed(base)) base.upSpeedBuild();
  }
//функция,  добавляем, сортируем наши, нейтральные и чужие базы по количеству кораблей, сначала с меньшим

  if (basesNeutral.isNotEmpty) {
    for (BaseObject baseN in basesNeutral) {
      List<int> listOur = isAttacCheck(basesOur, baseN);
      if (listOur.isNotEmpty) {
        if (listOur.length > 3) listOur = listOur.getRange(0, 2).toList();
        sendShips(block, basesOur, listOur, baseN.index);
      }
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }
  sort();
  await Future.delayed(const Duration(milliseconds: 200));
  if (basesEnemy.isNotEmpty) {
    for (BaseObject base in basesEnemy) {
      List<int> listOur = isAttacCheck(basesOur, base);
      if (listOur.length > 3) listOur = listOur.getRange(0, 2).toList();
      if (listOur.isNotEmpty) {
        sendShips(block, basesOur, listOur, base.index);
      }
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }
  sort();
  await Future.delayed(const Duration(milliseconds: 200));
  if (basesOur.isNotEmpty) {
    for (BaseObject base in basesOur) {
      List<int> listOur = isAttacCheck(basesOur, base);
      if (listOur.length > 2) listOur = listOur.getRange(0, 2).toList();
      if (listOur.isNotEmpty) {
        sendShips(block, basesOur, listOur, base.index);
      }
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }
}

sendShips(
    BattleBloc block, List<BaseObject> bases, List<int> list, int toIndex) {
  for (int index in list) {
    block.add(SendEvent(
      toIndex,
      bases[index].index,
    ));
  }
}

List<int> isAttacCheck(List<BaseObject> bases, BaseObject enemyBase) {
  List<int> attackBaseIndex = [];
  double forceEnemy = enemyBase.ships + enemyBase.shild;
  double forceOur = 0;
  for (int k = 0; k < bases.length; k++) {
    if (getBase(bases[k].coordinates, enemyBase.coordinates) == null) {
      attackBaseIndex.add(k);
      forceOur += bases[k].ships;
    }
  }
  return (forceOur > forceEnemy) ? attackBaseIndex : [];
}

sortBaseShips(List<BaseObject> bases) {
  bases.sort((a, b) => (a.ships + a.shild).compareTo(b.ships + b.shild));
}
