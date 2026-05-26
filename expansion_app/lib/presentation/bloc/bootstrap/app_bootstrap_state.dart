import 'package:equatable/equatable.dart';

enum AppBootstrapStatus { idle, loading, ready, failed }

class AppBootstrapState extends Equatable {
  const AppBootstrapState({
    required this.status,
    this.errorMessage,
  });

  const AppBootstrapState.idle() : this(status: AppBootstrapStatus.idle);

  final AppBootstrapStatus status;
  final String? errorMessage;

  bool get isReady => status == AppBootstrapStatus.ready;

  AppBootstrapState copyWith({
    AppBootstrapStatus? status,
    String? errorMessage,
  }) {
    return AppBootstrapState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
