part of 'setting_bloc.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

class ChangeSound extends SettingEvent {}

class ChangeLang extends SettingEvent {
  final Lang lang;
  const ChangeLang(this.lang);
}
