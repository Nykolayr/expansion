import 'package:dartz/dartz.dart';

import 'package:expansion/core/error/failures.dart';

abstract class FeedbackRepository {
  Future<Either<Failure, void>> submit({
    required String message,
    String? guestEmail,
  });
}
