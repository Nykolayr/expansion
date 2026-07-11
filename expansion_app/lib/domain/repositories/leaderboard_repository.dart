import 'package:dartz/dartz.dart';

import 'package:expansion/core/error/failures.dart';
import 'package:expansion/domain/entities/leaderboard_entry.dart';

abstract class LeaderboardRepository {
  Future<Either<Failure, LeaderboardResult>> fetchTop({int limit = 50});
}
