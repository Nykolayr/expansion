import 'package:dartz/dartz.dart';

import 'package:expansion/core/error/exceptions.dart';
import 'package:expansion/core/error/failures.dart';
import 'package:expansion/data/datasources/remote/leaderboard_remote_datasource.dart';
import 'package:expansion/domain/entities/leaderboard_entry.dart';
import 'package:expansion/domain/repositories/leaderboard_repository.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  LeaderboardRepositoryImpl(this._remote);

  final LeaderboardRemoteDataSource _remote;

  @override
  Future<Either<Failure, LeaderboardResult>> fetchTop({int limit = 50}) async {
    try {
      return Right(await _remote.fetchTop(limit: limit));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Unknown error'));
    }
  }
}
