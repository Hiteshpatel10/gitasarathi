import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/bookmarks_repository.dart';
import '../model/bookmark_models.dart';
part 'bookmarks_provider.g.dart';

@Riverpod(keepAlive: true)
class BookmarksNotifier extends _$BookmarksNotifier {
  @override
  FutureOr<Set<int>> build() async {
    final repo = ref.watch(bookmarksRepositoryProvider);
    return repo.getFavorites();
  }

  Future<void> toggleBookmark(int verseId) async {
    final repo = ref.read(bookmarksRepositoryProvider);
    
    // Optimistic update
    final previousState = state;
    if (state.hasValue) {
      final current = Set<int>.from(state.value!);
      if (current.contains(verseId)) {
        current.remove(verseId);
        state = AsyncData(current);
        final success = await repo.removeFavorite(verseId);
        if (!success) {
          state = previousState;
        } else {
          ref.invalidate(favoriteVersesProvider);
        }
      } else {
        current.add(verseId);
        state = AsyncData(current);
        final success = await repo.addFavorite(verseId);
        if (!success) {
          state = previousState;
        } else {
          ref.invalidate(favoriteVersesProvider);
        }
      }
    }
  }
}

@riverpod
Future<List<BookmarkItem>> favoriteVerses(Ref ref) async {
  final repo = ref.watch(bookmarksRepositoryProvider);
  final list = await repo.getFavoriteDetails();
  return list.map((e) => BookmarkItem.fromJson(e as Map<String, dynamic>)).toList();
}
