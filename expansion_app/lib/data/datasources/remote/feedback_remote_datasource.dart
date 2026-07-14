import 'package:dio/dio.dart';

import 'package:expansion/core/error/error_handler.dart';

/// REST `/feedback` — обратная связь от игроков.
class FeedbackRemoteDataSource {
  FeedbackRemoteDataSource(this._dio);

  final Dio _dio;

  Future<void> submit({
    required String message,
    String? email,
  }) async {
    try {
      await _dio.post<void>(
        '/feedback',
        data: <String, dynamic>{
          'message': message,
          if (email != null && email.isNotEmpty) 'email': email,
        },
      );
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
