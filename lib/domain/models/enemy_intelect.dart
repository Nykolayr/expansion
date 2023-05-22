import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';

int getTargetBaseIndex(List<BaseObject> bases) {
  int maxNeutralShips = -1;
  int neutralBaseIndex = -1;
  for (int i = 0; i < bases.length; i++) {
    BaseObject base = bases[i];
    if (base.typeStatus == TypeStatus.neutral && base.ships > maxNeutralShips) {
      maxNeutralShips = base.ships;
      neutralBaseIndex = i;
    }
  }

  if (neutralBaseIndex != -1) {
    // есть нейтральная база с наибольшим кол-вом кораблей
    int neededShips =
        bases[neutralBaseIndex].maxShips - bases[neutralBaseIndex].ships;
    if (neededShips <= getOurShipsCount(bases)) {
      return neutralBaseIndex;
    }
  }

  if (getOurShipsCount(bases) == 0) {
    return getMostVulnerableEnemyBaseIndex(bases);
  }

  int ourBaseIndex = getOurMostStrongBaseIndex(bases);

  if (bases[ourBaseIndex].ships < bases[ourBaseIndex].maxShips) {
    // отправляем все корабли на укрепление нашей базы
    return ourBaseIndex;
  } else {
    // отправляем половину кораблей на укрепление наиболее уязвимых наших баз
    List<int> ourVulnerableBaseIndexes = getOurVulnerableBaseIndexes(bases);
    int shipsToSend =
        bases[ourBaseIndex].ships ~/ (2 * ourVulnerableBaseIndexes.length);
    for (int i = 0; i < ourVulnerableBaseIndexes.length; i++) {
      bases[ourBaseIndex].ships -= shipsToSend;
      bases[ourVulnerableBaseIndexes[i]].ships += shipsToSend;
    }
    return ourBaseIndex;
  }
}

int getOurShipsCount(List<BaseObject> bases) {
  int result = 0;
  for (int i = 0; i < bases.length; i++) {
    BaseObject base = bases[i];
    if (base.typeStatus == TypeStatus.our) {
      result += base.ships;
    }
  }
  return result;
}

int getMostVulnerableEnemyBaseIndex(List<BaseObject> bases) {
  int minEnemyShips = -1;
  int enemyBaseIndex = -1;
  for (int i = 0; i < bases.length; i++) {
    BaseObject base = bases[i];
    if (base.typeStatus == TypeStatus.enemy &&
        (minEnemyShips == -1 || base.ships < minEnemyShips)) {
      minEnemyShips = base.ships;
      enemyBaseIndex = i;
    }
  }
  return enemyBaseIndex;
}

int getOurMostStrongBaseIndex(List<BaseObject> bases) {
  int maxOurShips = -1;
  int ourBaseIndex = -1;
  for (int i = 0; i < bases.length; i++) {
    BaseObject base = bases[i];
    if (base.typeStatus == TypeStatus.our && base.ships > maxOurShips) {
      maxOurShips = base.ships;
      ourBaseIndex = i;
    }
  }
  return ourBaseIndex;
}

List<int> getOurVulnerableBaseIndexes(List<BaseObject> bases) {
  List<int> result = [];
  for (int i = 0; i < bases.length; i++) {
    BaseObject base = bases[i];
    if (base.typeStatus == TypeStatus.our && base.ships < base.maxShips) {
      result.add(i);
    }
  }
  return result;
}

