import 'package:equatable/equatable.dart';

class SupporterEntry extends Equatable {
  const SupporterEntry({
    required this.rank,
    required this.label,
    required this.totalRub,
    required this.donationCount,
  });

  final int rank;
  final String? label;
  final int totalRub;
  final int donationCount;

  @override
  List<Object?> get props => [rank, label, totalRub, donationCount];
}

class SupportersResult extends Equatable {
  const SupportersResult({
    required this.limit,
    required this.entries,
  });

  final int limit;
  final List<SupporterEntry> entries;

  @override
  List<Object?> get props => [limit, entries];
}
