import 'package:dio/dio.dart';

import 'package:expansion/core/network/dio_client.dart';

/// Проверка версии контента на сервере (MVP).
class ContentSyncService {
  ContentSyncService(this._dio);

  final Dio _dio;

  factory ContentSyncService.fromSl(DioClient client) =>
      ContentSyncService(client.dio);

  Future<int?> fetchRemoteContentVersion() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/content/version');
      final data = response.data;
      return data?['contentVersion'] as int?;
    } catch (_) {
      return null;
    }
  }
}
