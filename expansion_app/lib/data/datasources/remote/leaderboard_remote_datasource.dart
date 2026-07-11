import 'package:dio/dio.dart';

import 'package:expansion/core/error/error_handler.dart';
import 'package:expansion/domain/entities/leaderboard_entry.dart';

class LeaderboardRemoteDataSource {
  LeaderboardRemoteDataSource(this._dio);

  final Dio _dio;

  Future<LeaderboardResult> fetchTop({int limit = 50}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/leaderboard',
        queryParameters: <String, dynamic>{'limit': limit},
      );
      final data = response.data!;
      final entriesRaw = data['entries'] as List<dynamic>? ?? const [];
      final entries = entriesRaw.map((item) {
        final map = item as Map<String, dynamic>;
        return LeaderboardEntry(
          rank: map['rank'] as int,
          label: map['label'] as String,
          nick: map['nick'] as String,
          realName: map['realName'] as String? ?? '',
          scoreClassic: map['scoreClassic'] as int? ?? 0,
          mapClassic: map['mapClassic'] as int? ?? 1,
        );
      }).toList();

      return LeaderboardResult(
        limit: data['limit'] as int? ?? limit,
        entries: entries,
      );
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
