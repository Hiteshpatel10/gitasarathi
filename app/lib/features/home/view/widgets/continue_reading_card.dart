import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/router/route_destinations.dart';
import 'package:app/core/providers/global_audio_provider.dart';
import 'package:app/features/chapters/provider/chapters_providers.dart';
import '../../provider/home_providers.dart';

class ContinueReadingCard extends ConsumerWidget {
  const ContinueReadingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(lastActivityProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.saffronGold,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: activityAsync.when(
        data: (activity) {
          if (activity == null) {
            return const Text('Start your reading journey today!');
          }
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CONTINUE READING',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: context.colors.systemBackground.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Karma Yoga', // TODO: Map chapterId to Name
                    style: GoogleFonts.lora(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: context.colors.systemBackground,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Chapter ${activity.chapterId ?? 1} · Verse ${activity.verseId ?? 1}',
                    style: TextStyle(
                      fontSize: 12,
                      color: context.colors.systemBackground.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final vId = activity.verseId;
                          final cId = activity.chapterId ?? 1;
                          if (vId != null) {
                            context.pushDestination(VerseExplanationDestination(
                              chapterId: cId,
                              verseId: vId,
                            ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          side: BorderSide(color: context.colors.systemBackground),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        ),
                        child: Text(
                          'Read',
                          style: TextStyle(color: context.colors.systemBackground),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final vId = activity.verseId;
                          final cId = activity.chapterId ?? 1;
                          if (vId == null) return;
                          
                          final chapters = await ref.read(chaptersListProvider.future);
                          if (chapters != null) {
                            final chapter = chapters.firstWhere((c) => c.chapterNumber == cId || c.id == cId);
                            final fullVerse = await ref.read(verseExplanationProvider(vId).future);
                            if (fullVerse != null) {
                              await ref.read(globalAudioProvider.notifier).playVerse(fullVerse, chapter);
                              if (context.mounted) {
                                context.pushDestination(ListenDestination.instance);
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.systemBackground,
                          foregroundColor: context.colors.saffron,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        ),
                        icon: const Icon(Icons.play_arrow, size: 16),
                        label: const Text('Listen'),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                right: -20,
                bottom: -20,
                child: Text(
                  '${activity.chapterId ?? 3}',
                  style: GoogleFonts.lora(
                    fontSize: 120,
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withValues(alpha: 0.1),
                    height: 1,
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
        error: (err, stack) => const Text('Failed to load'),
      ),
    );
  }
}
