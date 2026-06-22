import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/core/network/dio_provider.dart';
import 'package:app/core/network/api_endpoints.dart';
import '../model/home_models.dart';

part 'home_repository.g.dart';

class HomeRepository {
  HomeRepository(this._dio);
  final Dio _dio;

  Future<LastActivity?> getLastActivity() async {
    try {
      final response = await _dio.get(ApiEndpoints.lastActivity);
      if (response.data['status'] == 1 && response.data['result'] != null) {
        return LastActivity.fromJson(response.data['result']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<StreakSummary?> getStreakSummary() async {
    try {
      final response = await _dio.get(ApiEndpoints.streakSummary);
      if (response.data['status'] == 1 && response.data['result'] != null) {
        return StreakSummary.fromJson(response.data['result']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<VerseOfTheDay?> getVerseOfTheDay({
    int commentaryAuthorId = 1,
    int translationAuthorId = 1,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.verseOfTheDay,
        data: {
          'verse_id': 1, // required by DTO validation; actual verse is computed server-side
          'commentary_author_id': commentaryAuthorId,
          'translation_author_id': translationAuthorId,
        },
      );
      if (response.data['status'] == 1 && response.data['result'] != null) {
        return VerseOfTheDay.fromJson(response.data['result']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

@riverpod
HomeRepository homeRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return HomeRepository(dio);
}
