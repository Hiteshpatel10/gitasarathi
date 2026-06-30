import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:app/core/network/api_endpoints.dart';
import 'package:app/core/network/dio_provider.dart';
import 'package:app/core/services/pref_service.dart';
import 'package:app/core/constants/pref_keys.dart';
import 'package:app/core/services/logger_service.dart';

final activityServiceProvider = Provider<ActivityService>((ref) {
  final dio = ref.watch(dioProvider);
  final prefService = ref.watch(prefServiceProvider);
  final logger = ref.watch(loggerProvider);
  return ActivityService(dio, prefService, logger);
});

class UserActivity {
  static const String chapterOpen = "Chapter Open";
  static const String verseRead = "Verse Read";
  static const String verseListen = "Verse Listen";
  static const String appOpen = "App Open";
  static const String share = "Share";
}

class ActivityService {
  final Dio _dio;
  final PrefService _prefService;
  final LoggerService _logger;

  ActivityService(this._dio, this._prefService, this._logger);

  Future<String> getOrCreateSessionId() async {
    String? sessionId = _prefService.getString(PrefKeys.sessionId);
    if (sessionId == null) {
      sessionId = const Uuid().v4();
      await _prefService.setString(PrefKeys.sessionId, sessionId);
    }
    return sessionId;
  }

  Future<void> insertUserActivity({
    int? chapterNo,
    int? verseNo,
    required String activity,
  }) async {
    if (kDebugMode) {
      _logger.i("ActivityService => insertUserActivity => Stopped (Debug Mode: $activity, chapter: $chapterNo, verse: $verseNo)");
      return;
    }

    _logger.d("ActivityService => insertUserActivity => Start: $activity");

    try {
      final sessionId = await getOrCreateSessionId();
      final postData = {
        "chapter_no": chapterNo,
        "verse_no": verseNo,
        "activity": activity,
        "session_id": sessionId,
      };

      final response = await _dio.post(
        ApiEndpoints.insertUserActivity,
        data: postData,
      );

      _logger.d("ActivityService => insertUserActivity => Success: $response");
    } catch (e, stack) {
      _logger.e("ActivityService => insertUserActivity => Error: $e", e, stack);
    }
  }
}
