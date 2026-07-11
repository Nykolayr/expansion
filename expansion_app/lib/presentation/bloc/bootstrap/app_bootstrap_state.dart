import 'package:equatable/equatable.dart';

enum AppBootstrapStatus { idle, loading, ready, failed }

class AppBootstrapState extends Equatable {
  const AppBootstrapState({
    required this.status,
    this.errorMessage,
    this.contentVersion,
    this.showNewMissionsBanner = false,
  });

  const AppBootstrapState.idle()
      : this(status: AppBootstrapStatus.idle);

  final AppBootstrapStatus status;
  final String? errorMessage;

  /// Версия контента в SQLite после seed/OTA.
  final int? contentVersion;

  /// Показать баннер «новые миссии» на splash.
  final bool showNewMissionsBanner;

  bool get isReady => status == AppBootstrapStatus.ready;

  AppBootstrapState copyWith({
    AppBootstrapStatus? status,
    String? errorMessage,
    int? contentVersion,
    bool? showNewMissionsBanner,
  }) {
    return AppBootstrapState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      contentVersion: contentVersion ?? this.contentVersion,
      showNewMissionsBanner:
          showNewMissionsBanner ?? this.showNewMissionsBanner,
    );
  }

  @override
  List<Object?> get props =>
      [status, errorMessage, contentVersion, showNewMissionsBanner];
}
