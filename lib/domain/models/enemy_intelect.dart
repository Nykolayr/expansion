import 'dart:math';

import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/ui/battle/bloc/battle_bloc.dart';
// import 'package:expansion/domain/models/entities/ships.dart';
import 'package:expansion/utils/value.dart';

void setStateEnemy(BattleBloc block) async {
  List<BaseObject> bases = gameRepository.gameData.bases;
  // List<Ship> ships = gameRepository.gameData.ships;
  List<BaseObject> basesNeutral = [];
  List<BaseObject> basesEnemy = [];
  List<BaseObject> basesOur = [];
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
        basesNeutral.add(base);
    }
  }
  if (basesOur.isEmpty) {
    block.add(WinEvent());
    return;
  }
  if (basesEnemy.isEmpty) {
    block.add(LostEvent());
    return;
  }
  sort() {
    sortBaseShips(basesNeutral);
    sortBaseShips(basesEnemy);
    sortBaseShips(basesOur);
  }

  int getAllShips(int lengthShips) {
    int allbaseShips = 0;
    for (int k = 0; k < lengthShips; k++) {
      allbaseShips += basesOur[basesOur.length - k - 1].ships;
    }
    return allbaseShips;
  }

  //сортируем наши и чужие базы по количеству кораблей
  sort();
  int allbaseShips = 0;
  int lengthShips = 1;
  if (basesOur.length > 2) {
    lengthShips = 3;
  } else {
    lengthShips = basesOur.length;
  }
  allbaseShips = getAllShips(lengthShips);
  if (basesNeutral.isNotEmpty) {
    if (basesNeutral.first.ships < allbaseShips - 1) {
      sendShips(block, basesOur, basesNeutral.first.index, lengthShips);
    }
  }

  await Future.delayed(const Duration(milliseconds: 100));
  sort();
  allbaseShips = getAllShips(lengthShips);
  if (basesEnemy.isNotEmpty) {
    if (basesEnemy.first.ships < allbaseShips - 30) {
      sendShips(block, basesOur, basesEnemy.first.index, lengthShips);
    }
  }
  await Future.delayed(const Duration(milliseconds: 100));
  sort();
  allbaseShips = getAllShips(lengthShips);
  if (basesOur.first.ships < 50) {
    sendShips(block, basesOur, basesOur.first.index, lengthShips);
  }
}

double calculateDistance(Point point1, Point point2) {
  double dx = point2.x.toDouble() - point1.x.toDouble();
  double dy = point2.y.toDouble() - point1.y.toDouble();
  double distance = sqrt(dx * dx + dy * dy);
  return distance;
}

sendShips(BattleBloc block, List<BaseObject> basesOur, int toIndex, int count) {
  for (int k = 0; k < count; k++) {
    block.add(SendEvent(
      toIndex,
      basesOur[basesOur.length - k - 1].index,
    ));
  }
}

sortBaseShips(List<BaseObject> bases) {
  bases.sort((a, b) => (a.ships + a.shild).compareTo(b.ships + b.shild));
}
