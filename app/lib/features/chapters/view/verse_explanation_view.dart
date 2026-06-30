import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/router/route_destinations.dart';
import '../../bookmarks/provider/bookmarks_provider.dart';
import '../provider/chapters_providers.dart';
import '../provider/verse_settings_provider.dart';
import '../model/verse_models.dart';
import 'package:app/core/providers/global_audio_provider.dart';
import 'package:app/core/router/app_routes.dart';
import 'package:share_plus/share_plus.dart';
import 'package:app/core/services/activity_service.dart';
import 'package:app/core/services/analytics_service.dart';

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
    ref.listen<AsyncValue<VerseDetails?>>(verseExplanationProvider(widget.verseId), (previous, next) {
      if (next is AsyncData && next.value != null) {
        final verse = next.value!;
        ref.read(activityServiceProvider).insertUserActivity(
          chapterNo: verse.chapterNumber,
          verseNo: verse.verseNumber,
          activity: UserActivity.verseRead,
        );
        ref.read(analyticsServiceProvider).logVerseRead(verse.id);
      }
    });

    final colors = context.colors;
    final verseAsync = ref.watch(verseExplanationProvider(widget.verseId));

    return Scaffold(
      backgroundColor: colors.systemBackground,
      appBar: AppBar(
        backgroundColor: colors.systemBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colors.label, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          verseAsync.value?.title ?? 'Loading...',
          style: TextStyle(
            color: colors.label,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.orange, size: 24),
            onPressed: () {
              final verse = verseAsync.value;
              if (verse != null) {
                final settings = ref.read(verseSettingsProvider);
                final translation = _getTranslation(verse, settings)?.description ?? '';
                final message = '''Radhey Radhey! 🌸✨

I just read a profound shloka from the Bhagavad Gita that resonated with me:

"$translation"  
(Bhagavad Gita ${verse.chapterNumber}.${verse.verseNumber})

Would you like to explore more? Read more on **Gita Sarathi**:  

📖 Read more:  
https://links.gitasarathi.geekaid.in/verse/${verse.id}

Hare Krishna! 🙏💛''';
                Share.share(message);
                ref.read(activityServiceProvider).insertUserActivity(
                  chapterNo: verse.chapterNumber,
                  verseNo: verse.verseNumber,
                  activity: UserActivity.share,
                );
                ref.read(analyticsServiceProvider).logShare(verse.id);
              }
            },
          ),
          Consumer(
            builder: (context, ref, child) {
              final isBookmarked = ref.watch(bookmarksProvider).maybeWhen(
                data: (bookmarks) => bookmarks.contains(widget.verseId),
                orElse: () => false,
              );
              return IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.orange,
                  size: 24,
                ),
                onPressed: () {
                  ref.read(bookmarksProvider.notifier).toggleBookmark(widget.verseId);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isBookmarked ? 'Removed from bookmarks' : 'Added to bookmarks'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.orange.withValues(alpha: 0.9),
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.orange, size: 24),
            onPressed: () {
              if (verseAsync.value != null) {
                _showSettingsBottomSheet(context, verseAsync.value!);
              }
            },
          ),
        ],
      ),
      body: verseAsync.when(
        data: (verse) {
          if (verse == null) {
            return Center(child: Text('Verse not found', style: TextStyle(color: colors.label)));
          }
          return _buildBody(context, colors, verse, ref.watch(verseSettingsProvider));
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.orange)),
        error: (error, stack) => Center(child: Text('Error: $error', style: TextStyle(color: colors.label))),
      ),
      bottomNavigationBar: verseAsync.whenOrNull(
        data: (verse) => verse != null ? _buildBottomNavigation(colors, verse) : null,
      ),
      floatingActionButton: verseAsync.whenOrNull(
        data: (verse) {
          if (verse?.audioLinks != null) {
            return FloatingActionButton(
              backgroundColor: colors.saffron,
              onPressed: () async {
                final chapters = await ref.read(chaptersListProvider.future);
                if (chapters != null) {
                  final chapter = chapters.firstWhere((c) => c.chapterNumber == verse!.chapterNumber);
                  await ref.read(globalAudioProvider.notifier).playVerse(verse!, chapter);
                  if (context.mounted) {
                    context.goNamed(AppRoutes.listen.name);
                  }
                }
              },
              child: const Icon(Icons.play_arrow, color: Colors.white, size: 28),
            );
          }
          return null;
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppThemeColors colors, VerseDetails verse, VerseSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSanskritCard(colors, verse),
          const SizedBox(height: 24),
          _buildWordByWordSection(colors, verse),
          const SizedBox(height: 24),
          _buildTranslationSection(colors, verse, settings),
          const SizedBox(height: 24),
          _buildCommentarySection(colors, verse, settings),
          const SizedBox(height: 100), // extra padding for bottom navigation and FAB
        ],
      ),
    );
  }

  VerseTranslation? _getTranslation(VerseDetails verse, VerseSettings settings) {
    if (verse.translations.isEmpty) return null;
    
    if (settings.selectedTranslatorId != null) {
      try {
        return verse.translations.firstWhere((t) => t.authorId == settings.selectedTranslatorId);
      } catch (_) {}
    }
    
    try {
      return verse.translations.firstWhere((t) => t.lang.toLowerCase() == settings.selectedLanguage.toLowerCase());
    } catch (_) {}
    
    return verse.translations.first;
  }

  VerseCommentary? _getCommentary(VerseDetails verse, VerseSettings settings) {
    if (verse.commentaries.isEmpty) return null;
    
    if (settings.selectedCommentatorId != null) {
      try {
        return verse.commentaries.firstWhere((c) => c.authorId == settings.selectedCommentatorId);
      } catch (_) {}
    }
    
    try {
      return verse.commentaries.firstWhere((c) => c.lang.toLowerCase() == settings.selectedLanguage.toLowerCase());
    } catch (_) {}
    
    return verse.commentaries.first;
  }

  Widget _buildSanskritCard(AppThemeColors colors, VerseDetails verse) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: colors.secondarySystemBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.label.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Text(
            verse.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.label,
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
              color: colors.secondaryLabel,
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
            color: colors.tertiaryLabel,
            fontSize: 12,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140, // Increased height to prevent text overflow
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
                        color: colors.secondaryLabel,
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

  Widget _buildTranslationSection(AppThemeColors colors, VerseDetails verse, VerseSettings settings) {
    final translation = _getTranslation(verse, settings);
    if (translation == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TRANSLATION',
              style: TextStyle(
                color: colors.tertiaryLabel,
                fontSize: 12,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              translation.authorName,
              style: TextStyle(
                color: Colors.orange.withValues(alpha: 0.8),
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
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
                      color: colors.label,
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

  Widget _buildCommentarySection(AppThemeColors colors, VerseDetails verse, VerseSettings settings) {
    final commentary = _getCommentary(verse, settings);
    if (commentary == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'COMMENTARY',
              style: TextStyle(
                color: colors.tertiaryLabel,
                fontSize: 12,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              commentary.authorName,
              style: TextStyle(
                color: Colors.orange.withValues(alpha: 0.8),
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
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
                  color: colors.label,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation(AppThemeColors colors, VerseDetails verse) {
    return Consumer(
      builder: (context, ref, child) {
        final versesAsync = ref.watch(chapterVersesProvider(verse.chapterId)); // Use chapterId based on API spec
        int? prevVerseId;
        int? nextVerseId;
        
        if (versesAsync.hasValue && versesAsync.value != null) {
          final verses = versesAsync.value!;
          final currentIndex = verses.indexWhere((v) => v.id == widget.verseId);
          if (currentIndex > 0) {
            prevVerseId = verses[currentIndex - 1].id;
          }
          if (currentIndex != -1 && currentIndex < verses.length - 1) {
            nextVerseId = verses[currentIndex + 1].id;
          }
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.secondarySystemBackground,
            border: Border(top: BorderSide(color: colors.separator)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous Button
                SizedBox(
                  width: 110,
                  child: OutlinedButton(
                    onPressed: prevVerseId != null
                        ? () {
                            final dest = VerseExplanationDestination(
                              chapterId: verse.chapterNumber,
                              verseId: prevVerseId!,
                            );
                            context.pushReplacementNamed(
                              dest.name,
                              pathParameters: dest.pathParameters,
                            );
                          }
                        : null,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: prevVerseId != null ? Colors.orange : Colors.grey),
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chevron_left, color: prevVerseId != null ? Colors.orange : Colors.grey, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          'Previous',
                          style: TextStyle(color: prevVerseId != null ? Colors.orange : Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Indicator
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Chapter ${verse.chapterNumber}',
                      style: TextStyle(color: colors.label, fontWeight: FontWeight.bold),
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

                const SizedBox(width: 16),

                // Next Button
                SizedBox(
                  width: 110,
                  child: ElevatedButton(
                    onPressed: nextVerseId != null
                        ? () {
                            final dest = VerseExplanationDestination(
                              chapterId: verse.chapterNumber,
                              verseId: nextVerseId!,
                            );
                            context.pushReplacementNamed(
                              dest.name,
                              pathParameters: dest.pathParameters,
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: nextVerseId != null ? Colors.orange : Colors.grey,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right, color: Colors.black, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSettingsBottomSheet(BuildContext context, VerseDetails verse) {
    final colors = context.colors;
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.secondarySystemBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final settings = ref.watch(verseSettingsProvider);
            final notifier = ref.read(verseSettingsProvider.notifier);

            // Extract available languages uniquely (case insensitive)
            final langs = <String>{};
            for (var t in verse.translations) {
              langs.add(t.lang.toLowerCase());
            }
            for (var c in verse.commentaries) {
              langs.add(c.lang.toLowerCase());
            }
            final availableLanguages = langs.toList()..sort();

            // Extract translators for selected language
            final availableTranslators = verse.translations
                .where((t) => t.lang.toLowerCase() == settings.selectedLanguage.toLowerCase())
                .toList();

            // Extract commentators for selected language
            final availableCommentators = verse.commentaries
                .where((c) => c.lang.toLowerCase() == settings.selectedLanguage.toLowerCase())
                .toList();

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Preferences',
                      style: TextStyle(
                        color: colors.label,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Language Selection
                    Text(
                      'Language',
                      style: TextStyle(color: colors.secondaryLabel, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: availableLanguages.map((lang) {
                        final isSelected = lang == settings.selectedLanguage.toLowerCase();
                        return ChoiceChip(
                          label: Text(lang[0].toUpperCase() + lang.substring(1)),
                          selected: isSelected,
                          selectedColor: Colors.orange,
                          backgroundColor: colors.tertiarySystemBackground,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.black : colors.label,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              notifier.setLanguage(lang);
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // Translator Selection
                    if (availableTranslators.isNotEmpty) ...[
                      Text(
                        'Translation by',
                        style: TextStyle(color: colors.secondaryLabel, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: availableTranslators.any((t) => t.authorId == settings.selectedTranslatorId) ? settings.selectedTranslatorId : null,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: colors.tertiarySystemBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        dropdownColor: context.colors.secondarySystemBackground,
                        style: TextStyle(color: colors.label),
                        icon: Icon(Icons.arrow_drop_down, color: colors.label),
                        hint: Text('Select a translator', style: TextStyle(color: colors.secondaryLabel)),
                        items: availableTranslators.map((t) {
                          return DropdownMenuItem<int>(
                            value: t.authorId,
                            child: Text(t.authorName, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) notifier.setTranslator(val);
                        },
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Commentator Selection
                    if (availableCommentators.isNotEmpty) ...[
                      Text(
                        'Commentary by',
                        style: TextStyle(color: colors.secondaryLabel, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: availableCommentators.any((c) => c.authorId == settings.selectedCommentatorId) ? settings.selectedCommentatorId : null,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: colors.tertiarySystemBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        dropdownColor: context.colors.secondarySystemBackground,
                        style: TextStyle(color: colors.label),
                        icon: Icon(Icons.arrow_drop_down, color: colors.label),
                        hint: Text('Select a commentator', style: TextStyle(color: colors.secondaryLabel)),
                        items: availableCommentators.map((c) {
                          return DropdownMenuItem<int>(
                            value: c.authorId,
                            child: Text(c.authorName),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) notifier.setCommentator(val);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
