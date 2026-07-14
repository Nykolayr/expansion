import 'package:dartz/dartz.dart';

import 'package:expansion/core/error/exceptions.dart';
import 'package:expansion/core/error/failures.dart';
import 'package:expansion/data/datasources/remote/feedback_remote_datasource.dart';
import 'package:expansion/domain/repositories/feedback_repository.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  FeedbackRepositoryImpl(this._remote);

  final FeedbackRemoteDataSource _remote;

  @override
  Future<Either<Failure, void>> submit({
    required String message,
    String? guestEmail,
  }) async {
    try {
      await _remote.submit(
        message: message.trim(),
        email: guestEmail?.trim(),
      );
      return const Right(null);
    } on BadRequestException catch (e) {
      return Left(AuthFailure(e.message, code: 'VALIDATION'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (_) {
      return const Left(ServerFailure('Unknown error'));
    }
  }
}
