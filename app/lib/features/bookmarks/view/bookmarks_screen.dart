import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/features/bookmarks/provider/bookmarks_provider.dart';
import 'package:app/features/bookmarks/view/widgets/bookmark_card.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookmarks'
        ),
      ),
      body: _buildBody(context, ref),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(favoriteVersesProvider);
    final bookmarkedVerseIdsAsync = ref.watch(bookmarksProvider);
    final bookmarkedVerseIds = bookmarkedVerseIdsAsync.value ?? {};

    final bookmarks = bookmarksAsync.value?.where((b) => bookmarkedVerseIds.contains(b.verseId)).toList();

    if (bookmarks == null && bookmarksAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (bookmarksAsync.hasError) {
      return Center(child: Text('Error: ${bookmarksAsync.error}'));
    }

    if (bookmarks == null) {
      return const SizedBox.shrink();
    }

    return CustomScrollView(
      slivers: [
        if (bookmarks.isEmpty)
          const SliverFillRemaining(
            child: Center(child: Text('No saved verses yet.')),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverList.separated(
              itemCount: bookmarks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = bookmarks[index];
                return BookmarkCard(bookmark: item);
              },
            ),
          ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }
}

