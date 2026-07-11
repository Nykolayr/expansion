import 'package:equatable/equatable.dart';

import 'package:expansion/domain/entities/leaderboard_entry.dart';

enum LeaderboardStatus { initial, loading, ready, failure }

class LeaderboardState extends Equatable {
  const LeaderboardState({
    this.status = LeaderboardStatus.initial,
    this.entries = const [],
    this.isLoggedIn = false,
    this.errorMessage,
  });

  final LeaderboardStatus status;
  final List<LeaderboardEntry> entries;
  final bool isLoggedIn;
  final String? errorMessage;

  LeaderboardState copyWith({
    LeaderboardStatus? status,
    List<LeaderboardEntry>? entries,
    bool? isLoggedIn,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LeaderboardState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, entries, isLoggedIn, errorMessage];
}
