import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repository/home_repository.dart';
import 'package:app/core/services/cache_service.dart';
import 'package:app/core/services/cache_events.dart';
import '../model/home_models.dart';

part 'home_providers.g.dart';

// ── Selected author preferences ───────────────────────────────────────────────

/// Currently selected translation author ID.
/// Changing this instantly rebuilds filteredVerseProvider with zero network calls.
@riverpod
class SelectedTranslationAuthorId extends _$SelectedTranslationAuthorId {
  @override
  int build() => 1;

  void select(int id) => state = id;
}

/// Currently selected commentary author ID.
@riverpod
class SelectedCommentaryAuthorId extends _$SelectedCommentaryAuthorId {
  @override
  int build() => 1;

  void select(int id) => state = id;
}

// ── Home data providers ──────────────────────────────────────────────────────

@riverpod
Future<LastActivity?> lastActivity(Ref ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getLastActivity();
}

@riverpod
Future<StreakSummary?> streakSummary(Ref ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  return repository.getStreakSummary();
}

/// Fetches (or loads from cache) the full verse with ALL translations and commentaries.
@riverpod
Future<VerseOfTheDay?> verseOfTheDay(Ref ref) async {
  final repository = ref.watch(homeRepositoryProvider);
  
  // Use .select to ONLY rebuild if OUR specific key was invalidated.
  ref.watch(cacheInvalidationEventProvider.select(
    (keys) => keys.contains(CacheService.verseOfTheDay())
  ));

  // Return the cached verse immediately (if any) to prevent loader UI
  final verse = await repository.getVerseOfTheDay();

  // Run the validator in the background. It will update the CacheInvalidationEventProvider
  // which this provider now watches, so it will automatically rebuild if needed!
  repository.syncUserCache();

  return verse;
}

/// Derived provider: filters the cached verse by the currently selected authors.
/// This rebuilds instantly on author change — zero network calls.
@riverpod
VerseOfTheDay? filteredVerse(Ref ref) {
  final verse = ref.watch(verseOfTheDayProvider).maybeWhen(
        data: (v) => v,
        orElse: () => null,
      );
  if (verse == null) return null;

  final transAuthorId = ref.watch(selectedTranslationAuthorIdProvider);
  final commAuthorId = ref.watch(selectedCommentaryAuthorIdProvider);

  // Filter translations — fall back to first if preferred author not found
  final filteredTranslations = verse.verseTranslation?.isNotEmpty == true
      ? [
          verse.verseTranslation!.firstWhere(
            (t) => t.authorId == transAuthorId,
            orElse: () => verse.verseTranslation!.first,
          )
        ]
      : verse.verseTranslation;

  // Filter commentaries — fall back to first if preferred author not found
  final filteredCommentaries = verse.verseCommentary?.isNotEmpty == true
      ? [
          verse.verseCommentary!.firstWhere(
            (c) => c.authorId == commAuthorId,
            orElse: () => verse.verseCommentary!.first,
          )
        ]
      : verse.verseCommentary;

  return VerseOfTheDay(
    id: verse.id,
    chapterId: verse.chapterId,
    verseNumber: verse.verseNumber,
    text: verse.text,
    transliteration: verse.transliteration,
    wordMeanings: verse.wordMeanings,
    verseTranslation: filteredTranslations,
    verseCommentary: filteredCommentaries,
  );
}
