import 'package:dartz/dartz.dart';

import 'package:expansion/core/error/exceptions.dart';
import 'package:expansion/core/error/failures.dart';
import 'package:expansion/data/datasources/remote/supporters_remote_datasource.dart';
import 'package:expansion/domain/entities/supporter_entry.dart';
import 'package:expansion/domain/repositories/supporters_repository.dart';

class SupportersRepositoryImpl implements SupportersRepository {
  SupportersRepositoryImpl(this._remote);

  final SupportersRemoteDataSource _remote;

  @override
  Future<Either<Failure, SupportersResult>> fetchTop({int limit = 50}) async {
    try {
      return Right(await _remote.fetchTop(limit: limit));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Unknown error'));
    }
  }
}
