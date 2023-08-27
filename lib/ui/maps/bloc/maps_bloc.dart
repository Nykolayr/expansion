import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'maps_event.dart';
part 'maps_state.dart';

class MapsBloc extends Bloc<MapsEvent, MapsState> {
  MapsBloc() : super(MapsState.initial()) {
    on<MapsBeginEvent>(_onNextEvent);
    on<MapsEndEvent>(_onMapsEndEvent);
    on<MapsMoveEvent>(_onMapsMoveEvent);
    on<MapsShowEvent>(_onMapsShowEvent);
  }

  _onNextEvent(MapsBeginEvent event, Emitter<MapsState> emit) async {
    emit(state.copyWith(isBegin: true));
  }

  _onMapsShowEvent(MapsShowEvent event, Emitter<MapsState> emit) async {
    emit(state.copyWith(isShow: true));
  }

  _onMapsMoveEvent(MapsMoveEvent event, Emitter<MapsState> emit) async {
    emit(state.copyWith(isMove: true));
  }

  _onMapsEndEvent(MapsEndEvent event, Emitter<MapsState> emit) async {
    await Future.delayed(const Duration(milliseconds: 3000));
    emit(state.copyWith(isNext: true));
  }
}
