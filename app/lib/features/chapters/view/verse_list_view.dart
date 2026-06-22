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
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolled = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrent(int currentIndex) {
    if (_hasScrolled || !_scrollController.hasClients) return;
    
    final targetOffset = currentIndex * VerseMapNode.nodeHeight;
    final viewportHeight = MediaQuery.of(context).size.height;
    final centeredOffset = (targetOffset - viewportHeight / 2).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Chapter ${widget.chapterId}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
          final completedCount = ((progressPct / 100) * verses.length).floor();
          
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToCurrent(completedCount);
          });

          return ListView.builder(
            controller: _scrollController,
            reverse: true,
            padding: const EdgeInsets.symmetric(vertical: 100),
            itemCount: verses.length,
            itemBuilder: (context, index) {
              final verse = verses[index];
              
              VerseState state;
              if (index < completedCount) {
                state = VerseState.completed;
              } else if (index == completedCount) {
                state = VerseState.current;
              } else {
                state = VerseState.locked;
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
          );
        },
      ),
    );
  }
}
