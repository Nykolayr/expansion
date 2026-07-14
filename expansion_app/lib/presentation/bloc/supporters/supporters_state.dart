import 'package:equatable/equatable.dart';

import 'package:expansion/domain/entities/supporter_entry.dart';

enum SupportersStatus { initial, loading, ready, failure }

class SupportersState extends Equatable {
  const SupportersState({
    this.status = SupportersStatus.initial,
    this.entries = const [],
    this.errorMessage,
  });

  final SupportersStatus status;
  final List<SupporterEntry> entries;
  final String? errorMessage;

  SupportersState copyWith({
    SupportersStatus? status,
    List<SupporterEntry>? entries,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SupportersState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, entries, errorMessage];
}
