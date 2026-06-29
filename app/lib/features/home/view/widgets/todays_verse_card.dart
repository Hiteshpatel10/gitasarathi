import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/router/route_destinations.dart';
import 'package:app/core/providers/global_audio_provider.dart';
import 'package:app/features/chapters/provider/chapters_providers.dart';
import '../../provider/home_providers.dart';
import '../../model/home_models.dart';

class TodaysVerseCard extends ConsumerWidget {
  const TodaysVerseCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use filteredVerseProvider — updates instantly when author preference changes
    final verse = ref.watch(filteredVerseProvider);

    // Also watch the full async state for loading/error
    final verseAsync = ref.watch(verseOfTheDayProvider);

    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Verse",
              style: GoogleFonts.lora(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors.label,
              ),
            ),
            // Author switcher button — only visible when verse data is loaded
            if (verse != null)
              GestureDetector(
                onTap: () => _showAuthorSwitcher(context, ref, verse),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: colors.saffron.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.swap_horiz, color: colors.saffron, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'Switch',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colors.saffron,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: colors.secondarySystemBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border(
              left: BorderSide(
                color: colors.saffron,
                width: 4,
              ),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: verseAsync.when(
            data: (_) {
              if (verse == null) return const SizedBox.shrink();

              final translation = verse.verseTranslation?.isNotEmpty == true
                  ? verse.verseTranslation!.first
                  : null;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BG ${verse.chapterId}.${verse.verseNumber}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colors.saffron,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    verse.text,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: colors.label,
                    ),
                  ),
                  if (translation != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      translation.authorName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: colors.saffron,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      translation.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.secondaryLabel,
                        height: 1.5,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pushDestination(VerseExplanationDestination(
                            chapterId: verse.chapterId,
                            verseId: verse.id,
                          ));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Read',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colors.saffron,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.menu_book, color: colors.saffron, size: 14),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: () async {
                          final chapters = await ref.read(chaptersListProvider.future);
                          if (chapters != null) {
                            final chapter = chapters.firstWhere((c) => c.chapterNumber == verse.chapterId);
                            final fullVerse = await ref.read(verseExplanationProvider(verse.id).future);
                            if (fullVerse != null) {
                              await ref.read(globalAudioProvider.notifier).playVerse(fullVerse, chapter);
                              if (context.mounted) {
                                context.pushDestination(ListenDestination.instance);
                              }
                            }
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Listen',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: colors.saffron,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.play_circle_fill, color: colors.saffron, size: 14),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => const Text('Failed to load'),
          ),
        ),
      ],
    );
  }

  void _showAuthorSwitcher(BuildContext context, WidgetRef ref, VerseOfTheDay verse) {
    final colors = context.colors;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.secondarySystemBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Consumer(
          builder: (ctx, ref, _) {
            final selectedId = ref.watch(selectedTranslationAuthorIdProvider);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Translation',
                    style: GoogleFonts.lora(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.label,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Full verse has ALL translations in cache — list them all
                  ...ref.read(verseOfTheDayProvider).maybeWhen(
                        data: (v) => v?.verseTranslation?.map((t) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(t.authorName, style: TextStyle(color: colors.label)),
                            subtitle: t.lang != null
                                ? Text(t.lang!, style: TextStyle(color: colors.secondaryLabel, fontSize: 12))
                                : null,
                            trailing: selectedId == t.authorId
                                ? Icon(Icons.check_circle, color: colors.saffron)
                                : Icon(Icons.circle_outlined, color: colors.separator),
                            onTap: () {
                              ref.read(selectedTranslationAuthorIdProvider.notifier).select(t.authorId);
                              Navigator.pop(ctx);
                            },
                          );
                        }).toList() ?? [const Text('No translations available')],
                        orElse: () => [const Text('No translations available')],
                      ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
