import 'package:dio/dio.dart';

import 'package:expansion/core/error/error_handler.dart';

class CampaignContentVersionInfo {
  const CampaignContentVersionInfo({
    required this.contentVersion,
    required this.sceneCount,
  });

  final int contentVersion;
  final int sceneCount;
}

/// REST `/content/*` — OTA кампания.
class CampaignContentRemoteDataSource {
  CampaignContentRemoteDataSource(this._dio);

  final Dio _dio;

  Future<CampaignContentVersionInfo?> fetchVersion() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/content/version');
      final data = response.data;
      if (data == null) return null;
      final version = data['contentVersion'] as int?;
      if (version == null) return null;
      return CampaignContentVersionInfo(
        contentVersion: version,
        sceneCount: data['sceneCount'] as int? ?? 0,
      );
    } on DioException {
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchPack() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/content/pack');
      return response.data;
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}

/// Распаковка payload сервера (тот же формат, что bundled assets).
abstract final class CampaignContentPackParser {
  static int readVersion(Map<String, dynamic> pack) {
    return pack['contentVersion'] as int? ?? 0;
  }

  static Map<String, dynamic> decodeLayouts(Map<String, dynamic> pack) {
    final raw = pack['layouts'];
    if (raw is Map<String, dynamic>) return raw;
    return {};
  }

  static List<dynamic> decodeScenesList(Map<String, dynamic> pack) {
    final raw = pack['scenes'];
    if (raw is List<dynamic>) return raw;
    return const [];
  }
}
