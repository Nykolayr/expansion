import 'dart:isolate';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:expansion/data/game_data.dart';
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
  }
  GameData gameData = gameRepository.gameData;
  int ticHold = 0;
  bool isSend = false;
  int ticEnemy = 0;
  ReceivePort receivePort = ReceivePort();

  _onArriveShipsEvent(ArriveShipsEvent event, Emitter<BattleState> emit) async {
    BaseObject toBase = gameData.bases[event.toIndex];
    Ship ship = gameData.ships[event.index];
    if (toBase.typeStatus == ship.typeStatus) {
      toBase.ships += ship.ships;
      gameData.ships.removeAt(event.index);
    } else {
      int shipCount = ship.ships;
      ship.isAttack = true;
      emit(state.copyWith(
        ships: gameData.ships,
        bases: gameData.bases,
        index: -1,
        toIndex: -1,
      ));

      await Future.delayed(const Duration(milliseconds: 500), () {
        gameData.ships.removeAt(event.index);
        emit(state.copyWith(
          bases: gameData.bases,
          ships: gameData.ships,
        ));

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
        }
      });
    }
    emit(state.copyWith(
      bases: gameData.bases,
      ships: gameData.ships,
    ));
  }

  _onSend(SendEvent event, Emitter<BattleState> emit) async {
    if (state.isLost || state.isWin || state.isPause) return;
    int toIndex = event.index;
    int index = event.send;
    ActionObject action = ActionObject.attack;
    if (state.bases[toIndex].typeStatus == state.bases[index].typeStatus) {
      action = ActionObject.support;
    }
    EntitesObject toBase = state.bases[toIndex];
    EntitesObject fromBase = state.bases[index];
    Point to = toBase.coordinates;
    Point from = fromBase.coordinates;
    int ships = fromBase.ships;
    if (ships > 0) {
      gameData.ships.add(Ship(
        index: gameData.ships.length,
        fromIndex: index,
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
        size: (40),
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
      ticEnemy = 0;
    }
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
