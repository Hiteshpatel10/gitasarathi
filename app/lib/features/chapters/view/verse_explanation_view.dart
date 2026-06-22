import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/theme/app_colors.dart';
import '../provider/chapters_providers.dart';
import '../model/verse_models.dart';

class VerseExplanationView extends ConsumerStatefulWidget {
  const VerseExplanationView({
    super.key,
    required this.verseId,
  });

  final int verseId;

  @override
  ConsumerState<VerseExplanationView> createState() => _VerseExplanationViewState();
}

class _VerseExplanationViewState extends ConsumerState<VerseExplanationView> {
  // Add a local state variable to override the provider verse if user navigates previous/next
  // But wait, the route handles the verseId. We can just context.pushReplacement or something,
  // or we can handle it via state. Let's use route param for simplicity.
  
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final verseAsync = ref.watch(verseExplanationProvider(widget.verseId));

    return Scaffold(
      backgroundColor: colors.systemBackground,
      appBar: AppBar(
        backgroundColor: colors.systemBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          verseAsync.value?.title ?? 'Loading...',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.orange, size: 24),
            onPressed: () {
              // TODO: Share
            },
          ),
        ],
      ),
      body: verseAsync.when(
        data: (verse) {
          if (verse == null) {
            return const Center(child: Text('Verse not found', style: TextStyle(color: Colors.white)));
          }
          return _buildBody(context, colors, verse);
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.orange)),
        error: (error, stack) => Center(child: Text('Error: $error', style: const TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppThemeColors colors, VerseDetails verse) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSanskritCard(colors, verse),
                const SizedBox(height: 24),
                _buildWordByWordSection(colors, verse),
                const SizedBox(height: 24),
                _buildTranslationSection(colors, verse),
                const SizedBox(height: 24),
                _buildCommentarySection(colors, verse),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        _buildBottomNavigation(colors, verse),
      ],
    );
  }

  Widget _buildSanskritCard(AppThemeColors colors, VerseDetails verse) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: colors.secondarySystemBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text(
            verse.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              height: 1.8,
              fontFamily: 'Serif', // Devanagari often looks good in Serif
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 2,
            width: 40,
            color: Colors.orange,
          ),
          const SizedBox(height: 20),
          Text(
            verse.transliteration,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 16,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordByWordSection(AppThemeColors colors, VerseDetails verse) {
    final words = verse.parsedWordMeanings;
    if (words.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WORD BY WORD',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: words.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final w = words[index];
              return Container(
                width: 120,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.secondarySystemBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      w.word,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      w.meaning,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTranslationSection(AppThemeColors colors, VerseDetails verse) {
    if (verse.translations.isEmpty) return const SizedBox.shrink();
    // Default to the first available translation
    final translation = verse.translations.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TRANSLATION',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.secondarySystemBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 3,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    translation.description,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentarySection(AppThemeColors colors, VerseDetails verse) {
    if (verse.commentaries.isEmpty) return const SizedBox.shrink();
    final commentary = verse.commentaries.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'COMMENTARY',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.secondarySystemBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                commentary.description,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Commentary by ${commentary.authorName}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation(AppThemeColors colors, VerseDetails verse) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.secondarySystemBackground,
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous Button
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Previous verse navigation
              },
              icon: const Icon(Icons.chevron_left, color: Colors.orange, size: 20),
              label: const Text(
                'Previous',
                style: TextStyle(color: Colors.orange),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.orange),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
            ),

            // Indicator (e.g. 47 / 78) - We need the total verse count from somewhere
            // Actually, verse order might just be global verse number, but let's just show verseNumber
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Verse ${verse.verseNumber}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),

            // Next Button
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Next verse navigation
              },
              icon: const Text(
                'Next',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              label: const Icon(Icons.chevron_right, color: Colors.black, size: 20),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
