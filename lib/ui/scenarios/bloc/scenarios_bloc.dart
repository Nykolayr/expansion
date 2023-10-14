// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expansion/domain/models/entities/base.dart';

part 'scenarios_event.dart';
part 'scenarios_state.dart';

class ScenariosBloc extends Bloc<ScenariosEvent, ScenariosState> {
  ScenariosBloc() : super(ScenariosState.initial()) {
    on<ScenariosEvent>((event, emit) {
      // on<InitEvent>(_onInit);
    });
  }
}
