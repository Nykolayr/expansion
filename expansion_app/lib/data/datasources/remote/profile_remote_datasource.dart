import 'package:dio/dio.dart';

import 'package:expansion/core/error/error_handler.dart';
import 'package:expansion/data/models/guest_profile_json_codec.dart';
import 'package:expansion/domain/entities/guest_profile.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this._dio);

  final Dio _dio;

  Future<GuestProfile> fetchProfile() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/profile');
      return GuestProfileJsonCodec.fromApi(response.data!);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<GuestProfile> updateProfile(
    GuestProfile profile, {
    String? realName,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/profile',
        data: GuestProfileJsonCodec.toApi(profile, realName: realName),
      );
      return GuestProfileJsonCodec.fromApi(response.data!);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
