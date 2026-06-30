import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/services/logger_service.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final logger = ref.watch(loggerProvider);
  return AnalyticsService(logger);
});

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final LoggerService _logger;

  AnalyticsService(this._logger);

  FirebaseAnalyticsObserver getObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }

  Future<void> logAppOpen() async {
    _logger.d("AnalyticsService => logAppOpen");
    try {
      await _analytics.logAppOpen();
    } catch (e, stack) {
      _logger.e("AnalyticsService => logAppOpen error: $e", e, stack);
    }
  }

  Future<void> logChapterOpen(int chapterId) async {
    _logger.d("AnalyticsService => logChapterOpen: $chapterId");
    try {
      await _analytics.logEvent(
        name: 'chapter_open',
        parameters: {
          'chapter_id': chapterId,
        },
      );
    } catch (e, stack) {
      _logger.e("AnalyticsService => logChapterOpen error: $e", e, stack);
    }
  }

  Future<void> logVerseRead(int verseId) async {
    _logger.d("AnalyticsService => logVerseRead: $verseId");
    try {
      await _analytics.logEvent(
        name: 'verse_read',
        parameters: {
          'verse_id': verseId,
        },
      );
    } catch (e, stack) {
      _logger.e("AnalyticsService => logVerseRead error: $e", e, stack);
    }
  }

  Future<void> logVerseListen(int verseId) async {
    _logger.d("AnalyticsService => logVerseListen: $verseId");
    try {
      await _analytics.logEvent(
        name: 'verse_listen',
        parameters: {
          'verse_id': verseId,
        },
      );
    } catch (e, stack) {
      _logger.e("AnalyticsService => logVerseListen error: $e", e, stack);
    }
  }

  Future<void> logShare(int verseId) async {
    _logger.d("AnalyticsService => logShare: $verseId");
    try {
      await _analytics.logShare(
        contentType: 'verse',
        itemId: verseId.toString(),
        method: 'share_plus',
      );
    } catch (e, stack) {
      _logger.e("AnalyticsService => logShare error: $e", e, stack);
    }
  }

  Future<void> setUserProperties(String email) async {
    _logger.d("AnalyticsService => setUserProperties: $email");
    try {
      await _analytics.setUserId(id: email);
      await _analytics.setUserProperty(name: 'user_email', value: email);
    } catch (e, stack) {
      _logger.e("AnalyticsService => setUserProperties error: $e", e, stack);
    }
  }
}
