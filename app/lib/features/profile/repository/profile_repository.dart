import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/network/dio_provider.dart';
import 'package:app/core/network/api_endpoints.dart';

class ProfileRepository {
  final Dio _dio;

  ProfileRepository(this._dio);

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.user);
      if (response.data['status'] == 1 && response.data['result'] != null) {
        return response.data['result'] as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserProgress() async {
    try {
      final response = await _dio.get(ApiEndpoints.progress);
      if (response.data['status'] == 1 && response.data['result'] != null) {
        return response.data['result'] as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ProfileRepository(dio);
});
