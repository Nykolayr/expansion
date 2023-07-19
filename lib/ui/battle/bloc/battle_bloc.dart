import 'dart:isolate';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:expansion/data/game_data.dart';
import 'package:expansion/domain/models/enemy_intelect.dart';
import 'package:expansion/domain/models/entities/asteroids.dart';
import 'package:expansion/domain/models/entities/entities.dart';
import 'package:expansion/domain/models/entities/entity_space.dart';
import 'package:expansion/domain/models/entities/ships.dart';
import 'package:expansion/game_core/game_loop.dart';
import 'package:expansion/utils/colors.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'battle_event.dart';
part 'battle_state.dart';

class BattleBloc extends Bloc<BattleEvent, BattleState> {
  BattleBloc() : super(BattleState.initial()) {
    on<InitEvent>(_onInit);
    on<TicEvent>(_onIic);
    on<PressEvent>(_onPress);
    on<SendEvent>(_onSend);
    on<ArriveShipsEvent>(_onArriveShipsEvent);
    on<WinEvent>(_onWin);
    on<LostEvent>(_onLost);
    on<PauseEvent>(_onPause);
    on<PlayEvent>(_onPlay);
    on<CloseEvent>(_onClose);
    on<ArriveAsteroidEvent>(_onArriveAsteroidEvent);
    on<BattleShipsEvent>(_onBattleShipsEvent);
  }
  GameData gameData = gameRepository.gameData;
  int ticHold = 0;
  bool isSend = false;
  int ticEnemy = 0;
  int ticAsteroid = 0;
  ReceivePort receivePort = ReceivePort();
  _onBattleShipsEvent(BattleShipsEvent event, Emitter<BattleState> emit) async {
    try {
      EntitesObject enemyShip = state.ships
          .firstWhere((element) => element.index == event.enemyIndex);
      EntitesObject ourShip =
          state.ships.firstWhere((element) => element.index == event.indexShip);
      if (enemyShip.ships > ourShip.ships) {
        enemyShip.ships -= ourShip.ships;
        (enemyShip as Ship).isAttack = false;
        gameData.ships.removeWhere((element) {
          return element.index == ourShip.index;
        });
      } else {
        ourShip.ships -= enemyShip.ships;
        (ourShip as Ship).isAttack = false;
        gameData.ships.removeWhere((element) {
          return element.index == enemyShip.index;
        });
      }
      emit(state.copyWith(
        bases: gameData.bases,
        ships: gameData.ships,
      ));
    } catch (e) {}
  }

  _onArriveAsteroidEvent(
      ArriveAsteroidEvent event, Emitter<BattleState> emit) async {
    EntitesObject ast =
        gameData.ships.where((element) => element.index == event.index).first;
    if (event.indexBase != null) {
      BaseObject base = gameData.bases[event.indexBase!];

      if (base.shild > ast.ships) {
        base.shild -= ast.ships;
      } else {
        ast.size -= base.shild;
        base.shild = 0;
        base.ships =
            (base.ships < ast.size.toInt()) ? 0 : base.ships - ast.ships;
      }
    }
    if (event.indexShip != null) {
      EntitesObject ship = gameData.ships
          .where((element) => element.index == event.indexShip)
          .first;
      if (ship.ships < ast.ships) {
        gameData.ships.removeWhere((element) {
          return element.index == event.indexShip;
        });
      } else {
        ship.ships -= ast.ships;
      }
    }
    gameData.ships.removeWhere((element) {
      return element.index == event.index;
    });
    emit(state.copyWith(
      bases: gameData.bases,
      ships: gameData.ships,
    ));
  }

  _onArriveShipsEvent(ArriveShipsEvent event, Emitter<BattleState> emit) async {
    BaseObject toBase =
        gameData.bases.where((element) => element.index == event.toIndex).first;
    Ship ship = gameData.ships.where((element) {
      return element.index == event.index;
    }).first as Ship;

    if (event.indexShip != null) {
      Ship enemyShip = gameData.ships.where((element) {
        return element.index == event.index;
      }).first as Ship;
      Future.delayed(const Duration(milliseconds: 200), () {
        if (enemyShip.ships == ship.ships) {
          gameData.ships.removeWhere((element) {
            return element.index == ship.index;
          });
          gameData.ships.removeWhere((element) {
            return element.index == enemyShip.index;
          });
        }
        if (enemyShip.ships > ship.ships) {
          gameData.ships.removeWhere((element) {
            return element.index == ship.index;
          });
        } else {
          gameData.ships.removeWhere((element) {
            return element.index == enemyShip.index;
          });
        }
      });
      return;
    }
    if (toBase.typeStatus == ship.typeStatus) {
      toBase.ships += ship.ships;
      gameData.ships.removeWhere((element) {
        return element.index == ship.index;
      });
    } else {
      int shipCount = ship.ships;
      ship.isAttack = true;
      Future.delayed(const Duration(milliseconds: 200), () {
        gameData.ships.removeWhere((element) {
          return element.index == ship.index;
        });
      });
      if (toBase.shild > 0) {
        if (toBase.shild < shipCount) {
          toBase.shild = 0;
          shipCount = shipCount - toBase.shild.toInt();
        } else {
          toBase.shild = toBase.shild - shipCount;
          shipCount = 0;
        }
      }
      if (toBase.ships > shipCount) {
        toBase.ships = toBase.ships - shipCount;
      } else {
        toBase.ships = shipCount - toBase.ships;
        toBase.typeStatus = ship.typeStatus;
        toBase.speedBuild = ship.typeStatus.speedRoket;
        toBase.speedResources = ship.typeStatus.speedResources;
        toBase.resources = 0;
      }
    }
    emit(state.copyWith(
      bases: gameData.bases,
      ships: gameData.ships,
    ));
  }

  _onSend(SendEvent event, Emitter<BattleState> emit) async {
    if (state.isLost ||
        state.isWin ||
        state.isPause ||
        event.toIndex == event.fromIndex) return;
    int toIndex = event.toIndex;
    int fromIndex = event.fromIndex;
    ActionObject action = ActionObject.attack;
    if (state.bases[toIndex].typeStatus == state.bases[fromIndex].typeStatus) {
      action = ActionObject.support;
    }
    BaseObject toBase = state.bases[toIndex];
    BaseObject fromBase = state.bases[fromIndex];
    Point to = toBase.coordinates;
    Point from = fromBase.coordinates;
    int ships = fromBase.ships;
    BaseObject? betweenBase = getBase(fromBase.coordinates, toBase.coordinates);
    if (betweenBase != null) {
      await betweenBase.showIsNotMove();
      return;
    }
    if (ships > 1) {
      gameData.ships.add(Ship(
        index: Random().nextInt(1000000),
        fromIndex: fromIndex,
        toIndex: toIndex,
        speed: ourSpeed,
        isAttack: false,
        target: PointFly(Point(to.y + toBase.size / 2, to.x + toBase.size / 2)),
        fly: PointFly(
            Point(from.y + fromBase.size / 2, from.x + fromBase.size / 2)),
        ships: ships,
        coordinates: Point(from.y, from.x + fromBase.size / 2),
        typeStatus: fromBase.typeStatus,
        distance: 0,
        distanceCurrent: 0,
        size: 40,
      ));
    }
    fromBase.ships = 0;
    emit(state.copyWith(
      bases: gameData.bases,
      ships: gameData.ships,
      index: -1,
      toIndex: toIndex,
      action: action,
    ));
  }

  _onPress(PressEvent event, Emitter<BattleState> emit) async {
    emit(state.copyWith(index: event.index, action: ActionObject.tap));
  }

  _onInit(InitEvent event, Emitter<BattleState> emit) async {
    await gameData.loadMap();
    await Isolate.spawn(mainLoop, receivePort.sendPort);
    receivePort.listen((message) {
      add(TicEvent());
    });
  }

  _onIic(TicEvent event, Emitter<BattleState> emit) async {
    if (state.isLost || state.isWin || state.isPause) return;
    if (ticHold == maxHoldTic) {
      ticHold = 0;
      return;
    }

    if (ticEnemy == maxEnemyTic) {
      setStateEnemy(this);
      ticEnemy = 0;
    }
    if (ticAsteroid == maxAsteroidTic) {
      int index = Random().nextInt(1000000);

      gameData.ships.add(Asteroid.fromRandom(index));
      emit(state.copyWith(
        ships: gameData.ships,
      ));
      ticAsteroid = 0;
    }
    ticAsteroid++;
    ticHold++;
    ticEnemy++;
    for (var item in gameData.bases) {
      item.update();
    }
    for (var item in gameData.ships) {
      item.update();
    }
    emit(state.copyWith(bases: gameData.bases, ships: gameData.ships));
  }

  _onLost(LostEvent event, Emitter<BattleState> emit) async =>
      emit(state.copyWith(isLost: true));

  _onWin(WinEvent event, Emitter<BattleState> emit) async =>
      emit(state.copyWith(isWin: true));

  _onPause(PauseEvent event, Emitter<BattleState> emit) async =>
      emit(state.copyWith(isPause: false));

  _onPlay(PlayEvent event, Emitter<BattleState> emit) async =>
      emit(state.copyWith(isPause: true));

  _onClose(CloseEvent event, Emitter<BattleState> emit) async =>
      receivePort.close();
}

enum ActionObject {
  tap,
  attack,
  support,
  no;

  Color get colorCrossFire {
    switch (this) {
      case ActionObject.no:
        return Colors.transparent;
      case ActionObject.tap:
        return AppColor.darkYeloow;
      case ActionObject.attack:
        return AppColor.red;
      case ActionObject.support:
        return AppColor.darkGreen;
    }
  }
}

/// проверяет есть ли база на пути между базой с point1 и базой point2
/// возращает базу которая на пути, если нет, то возращает null
BaseObject? getBase(Point point1, Point point2) {
  GameData gameData = gameRepository.gameData;
  List<BaseObject> myList = gameData.bases;
  double minDistance = double.infinity;
  BaseObject? nearestObject;
  List<BaseObject> filteredList = myList
      .where((obj) => obj.coordinates != point1 && obj.coordinates != point2)
      .toList();
  for (BaseObject obj in filteredList) {
    if (distance(obj.coordinates, point1) <= obj.size) {
      return obj;
    }

    bool intersection = false;
    double distanceToObj = distance(obj.coordinates, point1);

    for (int t = 1; t <= 10; t++) {
      // Проверяем точки на пути с шагом 0.1
      double x = point1.x + (point2.x - point1.x) * t / 10;
      double y = point1.y + (point2.y - point1.y) * t / 10;

      if (distance(Point(x, y), obj.coordinates) <= obj.size) {
        intersection = true;
        break;
      }
    }

    if (intersection && distanceToObj < minDistance) {
      minDistance = distanceToObj;
      nearestObject = obj;
    }
  }

  return nearestObject;
}

double distance(Point p1, Point p2) {
  num dx = p2.x - p1.x;
  num dy = p2.y - p1.y;
  return sqrt(dx * dx + dy * dy);
}
