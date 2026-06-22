import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/core/network/dio_provider.dart';
import 'package:app/core/network/api_endpoints.dart';
import 'package:app/core/services/cache_service.dart';
import '../model/chapter_models.dart';

part 'chapters_repository.g.dart';

class ChaptersRepository {
  ChaptersRepository(this._dio, this._cache);
  final Dio _dio;
  final CacheService _cache;

  Future<List<Chapter>?> getChapters() async {
    final cacheKey = CacheService.chapterList();

    // 1. Try cache first
    final cached = await _cache.get(cacheKey);
    if (cached != null && cached['chapters'] != null) {
      try {
        final list = (cached['chapters'] as List)
            .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
            .toList();
        return list;
      } catch (e) {
        print('Error parsing cached chapters: $e');
        await _cache.invalidate(cacheKey);
      }
    }

    // 2. Fetch from backend
    try {
      final response = await _dio.get(ApiEndpoints.chaptersAndVerses);

      if (response.data['status'] == 1 && response.data['result'] != null) {
        final resultList = response.data['result'] as List;
        
        final chapters = resultList
            .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
            .toList();

        // Store in cache (versioning managed globally via runCacheValidatorList)
        await _cache.put(cacheKey, {'chapters': resultList}, version: 0);

        return chapters;
      }
      return null;
    } catch (e) {
      print('Error fetching chapters from backend: $e');
      return null;
    }
  }

  Future<List<VerseMetadata>?> getVerses(int chapterId) async {
    final cacheKey = CacheService.chapterList();
    
    // Since we fetch chaptersAndVerses, the raw JSON is stored in cache
    final cached = await _cache.get(cacheKey);
    if (cached != null && cached['chapters'] != null) {
      try {
        final list = cached['chapters'] as List;
        final chapterData = list.firstWhere(
          (e) => e['chapter_number'] == chapterId || e['id'] == chapterId,
          orElse: () => null,
        );

        if (chapterData != null && chapterData['verses'] != null) {
          final versesList = chapterData['verses'] as List;
          return versesList
              .map((e) => VerseMetadata.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      } catch (e) {
        print('Error extracting verses: $e');
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> getProgress() async {
    try {
      final response = await _dio.get(ApiEndpoints.progress);
      if (response.data['status'] == 1 && response.data['result'] != null) {
        return response.data['result'] as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error fetching progress from backend: $e');
      return null;
    }
  }
}

@riverpod
ChaptersRepository chaptersRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final cache = ref.watch(cacheServiceProvider);
  return ChaptersRepository(dio, cache);
}
