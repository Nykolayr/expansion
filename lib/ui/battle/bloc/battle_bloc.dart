import 'dart:isolate';

import 'package:equatable/equatable.dart';
import 'package:expansion/data/game_data.dart';
import 'package:expansion/domain/models/entities/base.dart';
import 'package:expansion/game_core/game_loop.dart';
import 'package:expansion/utils/value.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

part 'battle_event.dart';
part 'battle_state.dart';

class BattleBloc extends Bloc<BattleEvent, BattleState> {
  BattleBloc() : super(Battleinit()) {
    on<InitEvent>(_onInit);
    on<TicEvent>(_onIic);
  }
  GameData gameData = gameRepository.gameData;

  _onInit(InitEvent event, Emitter<BattleState> emit) async {
    await gameData.loadMap();
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(mainLoop, receivePort.sendPort);
    receivePort.listen((message) {
      add(TicEvent());
    });
  }

  _onIic(TicEvent event, Emitter<BattleState> emit) async {
    emit(Battleinit());
    for (var item in gameData.planets) {
      item.update();
    }
    emit(BattleChange.copyWith(gameData.planets));
  }
}
