part of 'maps_bloc.dart';

class MapsState {
  final bool isNext;
  final bool isMove;
  final bool isBegin;
  final bool isShow;

  MapsState({
    required this.isNext,
    required this.isMove,
    required this.isBegin,
    required this.isShow,
  });
  factory MapsState.initial() => MapsState(
        isNext: false,
        isMove: false,
        isBegin: false,
        isShow: false,
      );
  MapsState copyWith({
    bool? isNext,
    bool? isMove,
    bool? isBegin,
    bool? isShow,
  }) =>
      MapsState(
        isNext: isNext ?? this.isNext,
        isMove: isMove ?? this.isMove,
        isBegin: isBegin ?? this.isBegin,
        isShow: isShow ?? this.isShow,
      );
}
