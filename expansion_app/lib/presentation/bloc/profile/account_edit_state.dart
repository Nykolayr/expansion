import 'package:equatable/equatable.dart';

import 'package:expansion/presentation/bloc/auth/register_state.dart';

enum AccountEditStatus { initial, loading, success, failure }

class AccountEditState extends Equatable {
  const AccountEditState({
    this.status = AccountEditStatus.initial,
    this.nickStatus = NickCheckStatus.idle,
    this.nickReason,
    this.errorMessage,
    this.passwordChanged = false,
  });

  final AccountEditStatus status;
  final NickCheckStatus nickStatus;
  final String? nickReason;
  final String? errorMessage;
  final bool passwordChanged;

  AccountEditState copyWith({
    AccountEditStatus? status,
    NickCheckStatus? nickStatus,
    String? nickReason,
    String? errorMessage,
    bool? passwordChanged,
    bool clearNickReason = false,
    bool clearError = false,
  }) {
    return AccountEditState(
      status: status ?? this.status,
      nickStatus: nickStatus ?? this.nickStatus,
      nickReason: clearNickReason ? null : nickReason ?? this.nickReason,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      passwordChanged: passwordChanged ?? this.passwordChanged,
    );
  }

  @override
  List<Object?> get props =>
      [status, nickStatus, nickReason, errorMessage, passwordChanged];
}
