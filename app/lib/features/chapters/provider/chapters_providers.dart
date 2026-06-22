import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/chapter_models.dart';
import '../repository/chapters_repository.dart';
import 'package:app/core/services/cache_service.dart';
import 'package:app/core/services/cache_events.dart';

part 'chapters_providers.g.dart';

@riverpod
Future<List<Chapter>?> chaptersList(Ref ref) async {
  // 1. Listen for cache invalidation events triggered by syncUserCache()
  // We use .select to ONLY rebuild if OUR specific key was invalidated.
  ref.watch(cacheInvalidationEventProvider.select(
    (keys) => keys.contains(CacheService.chapterList())
  ));

  final repository = ref.watch(chaptersRepositoryProvider);
  
  // 2. Fetch the cached list or fresh from the API
  final chapters = await repository.getChapters();
  
  if (chapters == null) return null;

  // 3. Fetch user progress
  final progressData = await repository.getProgress();
  
  if (progressData == null) return chapters;

  // 4. Merge progress into chapters
  final reads = progressData['reads'] as List? ?? [];
  final listens = progressData['listens'] as List? ?? [];

  final readMap = {
    for (var r in reads) r['chapter']: (r['progress'] as num).toDouble()
  };
  final listenMap = {
    for (var l in listens) l['chapter']: (l['progress'] as num).toDouble()
  };

  return chapters.map((chapter) {
    return chapter.copyWith(
      progress: readMap[chapter.chapterNumber] ?? chapter.progress,
      listenProgress: listenMap[chapter.chapterNumber] ?? chapter.listenProgress,
    );
  }).toList();
}
