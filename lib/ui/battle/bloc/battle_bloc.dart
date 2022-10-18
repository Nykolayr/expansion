import 'dart:isolate';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:expansion/data/game_data.dart';
import 'package:expansion/game_core/game_loop.dart';
import 'package:expansion/utils/value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

part 'battle_event.dart';
part 'battle_state.dart';

class BattleBloc extends Bloc<BattleEvent, BattleState> {
  BattleBloc() : super(const BattleChange(100, 100)) {
    on<InitEvent>(_onInit);
    on<TicEvent>(_onIic);
  }
  GameData gameData = gameRepository.gameData;
  double x = size.width - 180;
  double y = size.height - 180;
  int gradus = 0;
  _onInit(InitEvent event, Emitter<BattleState> emit) async {
    await gameData.loadMap();
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(mainLoop, receivePort.sendPort);
    emit(BattleChange(x, y));
    receivePort.listen((message) {
      add(TicEvent());
    });
  }

  _onIic(TicEvent event, Emitter<BattleState> emit) async {
    gradus++;
    gradus++;
    if (gradus == 360) gradus = 0;
    double radians = (gradus * math.pi) / 180;
    x = center.width - 20 + 80 * cos(radians);
    y = center.height - 20 + 80 * sin(radians);
    emit(BattleChange.copyWith(x, y));
  }
}
