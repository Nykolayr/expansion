import 'package:dio/dio.dart';

import 'package:expansion/core/error/error_handler.dart';
import 'package:expansion/domain/entities/supporter_entry.dart';

class SupportersRemoteDataSource {
  SupportersRemoteDataSource(this._dio);

  final Dio _dio;

  Future<SupportersResult> fetchTop({int limit = 50}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/expansion/supporters',
        queryParameters: <String, dynamic>{'limit': limit},
      );
      final data = response.data!;
      final entriesRaw = data['entries'] as List<dynamic>? ?? const [];
      final entries = entriesRaw.map((item) {
        final map = item as Map<String, dynamic>;
        return SupporterEntry(
          rank: map['rank'] as int,
          label: map['label'] as String?,
          totalRub: map['totalRub'] as int? ?? 0,
          donationCount: map['donationCount'] as int? ?? 0,
        );
      }).toList();

      return SupportersResult(
        limit: data['limit'] as int? ?? limit,
        entries: entries,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
