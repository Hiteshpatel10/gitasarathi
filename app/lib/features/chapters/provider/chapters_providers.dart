import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/chapter_models.dart';
import '../model/verse_models.dart';
import '../repository/chapters_repository.dart';
import 'package:app/core/services/cache_service.dart';
import 'package:app/core/services/cache_events.dart';

part 'chapters_providers.g.dart';

@riverpod
class ChaptersList extends _$ChaptersList {
  @override
  Future<List<Chapter>?> build() async {
    // 1. Listen for cache invalidation events triggered by syncUserCache()
    ref.watch(cacheInvalidationEventProvider.select(
      (keys) => keys.contains(CacheService.chapterList())
    ));

    final repository = ref.watch(chaptersRepositoryProvider);
    
    // 2. Fetch the cached list or fresh from the API
    final chapters = await repository.getChapters();
    
    if (chapters != null) {
      // 3. Silently fetch progress and update state when done
      _silentlyUpdateProgress();
    }
    
    return chapters;
  }

  Future<void> _silentlyUpdateProgress() async {
    try {
      final repository = ref.read(chaptersRepositoryProvider);
      final progressData = await repository.getProgress();
      
      if (progressData == null || state.value == null) return;

      final chapters = state.value!;
      final reads = progressData.reads;
      final listens = progressData.listens;

      final readMap = {
        for (var r in reads) r.chapter: r.progress
      };
      final listenMap = {
        for (var l in listens) l.chapter: l.progress
      };
      final versesMap = {
        for (var r in reads) 
          r.chapter: (r.verses?.split(',').where((s) => s.isNotEmpty).map((s) => int.tryParse(s.trim()) ?? 0).where((i) => i > 0).toList() ?? <int>[])
      };

      final newChapters = chapters.map((chapter) {
        return chapter.copyWith(
          progress: readMap[chapter.chapterNumber] ?? chapter.progress,
          listenProgress: listenMap[chapter.chapterNumber] ?? chapter.listenProgress,
          readVerses: versesMap[chapter.chapterNumber] ?? chapter.readVerses,
        );
      }).toList();

      state = AsyncData(newChapters);
    } catch (e) {
      // Ignore errors for silent background fetch
    }
  }
}

@riverpod
Future<List<VerseMetadata>?> chapterVerses(Ref ref, int chapterId) async {
  // Ensure we wait for the main list to load first, 
  // as it populates the cache with the raw JSON we need to extract verses.
  await ref.watch(chaptersListProvider.future);
  
  final repository = ref.watch(chaptersRepositoryProvider);
  return repository.getVerses(chapterId);
}

@riverpod
Future<VerseDetails?> verseExplanation(Ref ref, int verseId) async {
  final repository = ref.watch(chaptersRepositoryProvider);
  return repository.getVerseExplanation(verseId);
}
