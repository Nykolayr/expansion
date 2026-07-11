import 'package:equatable/equatable.dart';

class LeaderboardEntry extends Equatable {
  const LeaderboardEntry({
    required this.rank,
    required this.label,
    required this.nick,
    required this.realName,
    required this.scoreClassic,
    required this.mapClassic,
  });

  final int rank;
  final String label;
  final String nick;
  final String realName;
  final int scoreClassic;
  final int mapClassic;

  @override
  List<Object?> get props =>
      [rank, label, nick, realName, scoreClassic, mapClassic];
}

class LeaderboardResult extends Equatable {
  const LeaderboardResult({
    required this.limit,
    required this.entries,
  });

  final int limit;
  final List<LeaderboardEntry> entries;

  @override
  List<Object?> get props => [limit, entries];
}
