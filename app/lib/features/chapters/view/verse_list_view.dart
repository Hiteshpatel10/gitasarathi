import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/theme/app_colors.dart';
import 'package:app/core/router/route_destinations.dart';
import '../provider/chapters_providers.dart';
import 'widgets/verse_map_node.dart';
import 'widgets/verse_map_button.dart';

class VerseListView extends ConsumerStatefulWidget {
  const VerseListView({super.key, required this.chapterId});
  
  final int chapterId;

  @override
  ConsumerState<VerseListView> createState() => _VerseListViewState();
}

class _VerseListViewState extends ConsumerState<VerseListView> {
  final GlobalKey<NestedScrollViewState> _nestedScrollKey = GlobalKey<NestedScrollViewState>();
  bool _hasScrolled = false;

  @override
  void dispose() {
    super.dispose();
  }

  void _scrollToCurrent(int currentIndex) {
    if (_hasScrolled) return;
    final innerController = _nestedScrollKey.currentState?.innerController;
    if (innerController == null || !innerController.hasClients) return;
    
    final targetOffset = currentIndex * VerseMapNode.nodeHeight;
    final viewportHeight = MediaQuery.of(context).size.height;
    final centeredOffset = (targetOffset - viewportHeight / 2).clamp(
      0.0,
      innerController.position.maxScrollExtent,
    );

    innerController.animateTo(
      centeredOffset,
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOutBack,
    );
    _hasScrolled = true;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    
    final versesAsync = ref.watch(chapterVersesProvider(widget.chapterId));
    final chaptersAsync = ref.watch(chaptersListProvider);

    return Scaffold(
      backgroundColor: colors.systemBackground,
      body: versesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (verses) {
          if (verses == null || verses.isEmpty) {
            return const Center(child: Text('No verses found'));
          }

          final chapters = chaptersAsync.value ?? [];
          final chapter = chapters.firstWhere(
            (c) => c.chapterNumber == widget.chapterId || c.id == widget.chapterId,
            orElse: () => chapters.first,
          );

          final progressPct = chapter.progress ?? 0.0;
          final completedCount = chapter.readVerses?.length ?? 0;
          
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToCurrent(completedCount);
          });

          return NestedScrollView(
            key: _nestedScrollKey,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: colors.systemBackground.withValues(alpha: 0.95),
                  expandedHeight: 120, // Height for progress bar + title
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    onPressed: () => context.pop(),
                  ),
                  title: Text(
                    '${chapter.nameTranslation} - Chapter ${chapter.chapterNumber}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Serif',
                    ),
                  ),
                  centerTitle: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '$completedCount OF ${verses.length} VERSES COMPLETED',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: progressPct / 100,
                                backgroundColor: Colors.white.withValues(alpha: 0.1),
                                valueColor: AlwaysStoppedAnimation<Color>(colors.saffron),
                                minHeight: 2,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: ListView.builder(
              padding: const EdgeInsets.only(top: 20, bottom: 100),
              itemCount: verses.length,
              itemBuilder: (context, index) {
                final verse = verses[index];
                
                final isRead = chapter.readVerses?.contains(verse.verseNumber) ?? false;
                
                VerseState state;
                if (isRead) {
                  state = VerseState.completed;
                } else {
                  // The first unread verse is the "current" one
                  final firstUnreadIndex = verses.indexWhere(
                    (v) => !(chapter.readVerses?.contains(v.verseNumber) ?? false)
                  );
                  if (index == firstUnreadIndex) {
                    state = VerseState.current;
                  } else {
                    state = VerseState.locked;
                  }
                }

                return VerseMapNode(
                  index: index,
                  verseNumber: verse.verseNumber,
                  isFirst: index == 0,
                  isLast: index == verses.length - 1,
                  state: state,
                  onTap: () {
                    // Navigate to verse explanation
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
