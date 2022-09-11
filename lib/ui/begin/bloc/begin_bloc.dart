import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'begin_event.dart';
part 'begin_state.dart';

class BeginBloc extends Bloc<BeginEvent, BeginState> {
  BeginBloc() : super(BeginInitial()) {
    on<BeginEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
