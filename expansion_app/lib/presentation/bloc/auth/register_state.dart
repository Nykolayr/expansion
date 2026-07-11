import 'package:equatable/equatable.dart';

enum RegisterStep { credentials, verification }

enum RegisterStatus { initial, loading, success, failure }

enum NickCheckStatus { idle, checking, available, unavailable }

class RegisterState extends Equatable {
  const RegisterState({
    this.step = RegisterStep.credentials,
    this.status = RegisterStatus.initial,
    this.nickStatus = NickCheckStatus.idle,
    this.nickReason,
    this.errorMessage,
    this.email = '',
    this.password = '',
    this.nick = '',
    this.realName = '',
    this.needsMerge = false,
  });

  final RegisterStep step;
  final RegisterStatus status;
  final NickCheckStatus nickStatus;
  final String? nickReason;
  final String? errorMessage;
  final String email;
  final String password;
  final String nick;
  final String realName;
  final bool needsMerge;

  RegisterState copyWith({
    RegisterStep? step,
    RegisterStatus? status,
    NickCheckStatus? nickStatus,
    String? nickReason,
    String? errorMessage,
    String? email,
    String? password,
    String? nick,
    String? realName,
    bool? needsMerge,
    bool clearError = false,
    bool clearNickReason = false,
  }) {
    return RegisterState(
      step: step ?? this.step,
      status: status ?? this.status,
      nickStatus: nickStatus ?? this.nickStatus,
      nickReason: clearNickReason ? null : nickReason ?? this.nickReason,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      password: password ?? this.password,
      nick: nick ?? this.nick,
      realName: realName ?? this.realName,
      needsMerge: needsMerge ?? this.needsMerge,
    );
  }

  @override
  List<Object?> get props => [
        step,
        status,
        nickStatus,
        nickReason,
        errorMessage,
        email,
        password,
        nick,
        realName,
        needsMerge,
      ];
}
