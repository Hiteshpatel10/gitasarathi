import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/router/route_destinations.dart';
import 'package:app/features/bookmarks/model/bookmark_models.dart';
import 'package:app/features/bookmarks/provider/bookmarks_provider.dart';

class BookmarkCard extends ConsumerWidget {
  const BookmarkCard({super.key, required this.bookmark});

  final BookmarkItem bookmark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verse = bookmark.verse;
    if (verse == null) {
      return const SizedBox.shrink(); // Hide if no verse data
    }

    final translation = verse.verseTranslation?.isNotEmpty == true
        ? verse.verseTranslation!.first.description ?? ''
        : '';

    // Calculate time ago
    String timeAgo = '';
    if (bookmark.createdAt != null) {
      final diff = DateTime.now().difference(bookmark.createdAt!);
      if (diff.inDays > 7) {
        final weeks = diff.inDays ~/ 7;
        timeAgo = '$weeks week${weeks > 1 ? 's' : ''} ago';
      } else if (diff.inDays > 0) {
        timeAgo = '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
      } else if (diff.inHours > 0) {
        timeAgo = '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
      } else {
        timeAgo = 'Just now';
      }
    }

    return Dismissible(
      key: ValueKey(bookmark.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: context.colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        ref.read(bookmarksProvider.notifier).toggleBookmark(verse.id);
      },
      child: GestureDetector(
        onTap: () {
          context.pushDestination(VerseExplanationDestination(
            chapterId: verse.chapterNumber,
            verseId: verse.id,
          ));
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.colors.secondarySystemBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.colors.separator),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.colors.tertiarySystemBackground,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'BG ${verse.chapterNumber}.${verse.verseNumber}',
                    style: TextStyle(
                      color: context.colors.saffron,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        ref.read(bookmarksProvider.notifier).toggleBookmark(verse.id);
                      },
                      child: Icon(
                        Icons.bookmark,
                        color: context.colors.saffron,
                        size: 20,
                      ),
                    ),
                    if (timeAgo.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        timeAgo,
                        style: TextStyle(
                          color: context.colors.secondaryLabel,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              verse.text?.replaceAll('\n', ' ') ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.colors.label,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (translation.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                translation.replaceAll('\n', ' '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: context.colors.secondaryLabel,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
  }
}
