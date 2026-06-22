import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:app/core/network/dio_provider.dart';
import 'package:app/core/network/api_endpoints.dart';
import 'package:app/core/services/cache_service.dart';
import 'package:app/core/services/cache_events.dart';
import '../model/home_models.dart';

part 'home_repository.g.dart';

class HomeRepository {
  HomeRepository(this._dio, this._cache, this._ref);
  final Dio _dio;
  final CacheService _cache;
  final Ref _ref;

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

  /// Syncs cache config from the user profile endpoint and returns a list of
  /// cache keys that were invalidated.
  Future<List<String>> syncUserCache() async {
    try {
      final response = await _dio.get(ApiEndpoints.user);
      if (response.data['status'] == 1 && response.data['cache_validators'] != null) {
        final validatorsList = (response.data['cache_validators'] as List)
            .map((e) => CacheValidator.fromJson(e as Map<String, dynamic>))
            .toList();
        
        final invalidatedKeys = await _cache.runCacheValidatorList(validatorsList);
        if (invalidatedKeys.isNotEmpty) {
          _ref.read(cacheInvalidationEventProvider.notifier).notify(invalidatedKeys);
        }
        return invalidatedKeys;
      }
    } catch (e) {
      // Silently fail if we can't sync cache config
    }
    return [];
  }

  /// Fetches verse-of-the-day with full cache support.
  ///
  /// The cache freshness is now managed globally by CacheService.runCacheValidatorList()
  /// based on the cache_validators returned by the backend.
  Future<VerseOfTheDay?> getVerseOfTheDay() async {
    final cacheKey = CacheService.verseOfTheDay();

    // 1. Try cache first (if it exists, it is valid because the validator didn't clear it)
    final cached = await _cache.get(cacheKey);
    if (cached != null) {
      try {
        return VerseOfTheDay.fromJson(cached);
      } catch (e, st) {
        print('Error parsing cached verse of the day: $e');
        await _cache.invalidate(cacheKey);
      }
    }

    // 2. Cache miss / stale — fetch all authors from backend
    try {
      final response = await _dio.post(
        ApiEndpoints.verseOfTheDay,
        data: {
          'verse_id': 1, // required by DTO; actual verse is computed server-side
          'all_authors': true,
        },
      );

      if (response.data['status'] == 1 && response.data['result'] != null) {
        final resultData = response.data['result'] as Map<String, dynamic>;
        final verseJson = resultData['verse'] as Map<String, dynamic>?;
        final verseVersion = resultData['verseVersion'] as int? ?? 0;

        if (verseJson == null) return null;

        // Store full verse with all translations in cache, along with its version
        await _cache.put(cacheKey, verseJson, version: verseVersion);

        return VerseOfTheDay.fromJson(verseJson);
      }
      print('Failed to get verse, status: ${response.data['status']}');
      return null;
    } catch (e, st) {
      print('Error fetching verse from backend: $e');
      return null;
    }
  }
}

@riverpod
HomeRepository homeRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final cache = ref.watch(cacheServiceProvider);
  return HomeRepository(dio, cache, ref);
}
