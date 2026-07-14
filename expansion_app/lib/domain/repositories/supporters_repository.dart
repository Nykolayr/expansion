import 'package:dartz/dartz.dart';

import 'package:expansion/core/error/failures.dart';
import 'package:expansion/domain/entities/supporter_entry.dart';

abstract class SupportersRepository {
  Future<Either<Failure, SupportersResult>> fetchTop({int limit = 50});
}
