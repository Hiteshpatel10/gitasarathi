import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/core/theme/app_colors.dart';
import '../../provider/home_providers.dart';

class TodaysVerseCard extends ConsumerWidget {
  const TodaysVerseCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verseAsync = ref.watch(verseOfTheDayProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Verse",
          style: GoogleFonts.lora(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: context.colors.label,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: context.colors.secondarySystemBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border(
              left: BorderSide(
                color: context.colors.saffron,
                width: 4,
              ),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: verseAsync.when(
            data: (verse) {
              if (verse == null) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BG ${verse.chapterId}.${verse.verseNumber}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: context.colors.saffron,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    verse.text,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: context.colors.label,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (verse.translations?.isNotEmpty == true)
                    Text(
                      verse.translations!.first.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: context.colors.secondaryLabel,
                        height: 1.5,
                      ),
                    ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Read more',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: context.colors.saffron,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward, color: context.colors.saffron, size: 14),
                      ],
                    ),
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
}
