import 'dart:async';
import 'package:chapter/chapter_module/bloc/chapters_and_verse_cubit.dart';
import 'package:chapter/chapter_module/model/chapter_model.dart';
import 'package:chapter/theme/core_colors.dart';
import 'package:chapter/utility/navigation/app_routes.dart';
import 'package:chapter/verse_module/bloc/verse_cubit.dart';
import 'package:chapter/verse_module/model/verse_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class VerseView extends StatefulWidget {
  const VerseView({
    super.key,
    required this.verseNo,
    required this.chapterNo,
  });

  final int chapterNo;
  final int verseNo;

  @override
  State<VerseView> createState() => _VerseViewState();
}

class _VerseViewState extends State<VerseView> {
  int _selectedAuthor = 0;
  int _selectedLanguage = 0;
  late final Chapters _chapter;
  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<VerseCubit>(context).getVerse(
      chapterNo: widget.chapterNo,
      verseNo: widget.verseNo,
    );

    final chapterModel = ChapterModel.fromJson(chapterData);
    _chapter = chapterModel.chapters![widget.chapterNo - 1];

    _updateTimer = Timer(const Duration(seconds: 6), () {
      // BlocProvider.of<ChapterCubit>(context).updateVerseRead(
      //   chapterNo: widget.chapterNo,
      //   verseNo: widget.verseNo,
      // );
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: BlocBuilder<VerseCubit, VerseState>(
        builder: (context, state) {
          if (state is VerseLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is VerseSuccess) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/flowers/orchid.png", height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Verse ${state.state.result?.verse}',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      Image.asset("assets/flowers/orchid.png", height: 16),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.state.result?.slok ?? '',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(height: 2),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 64),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/flowers/flower.png", height: 28),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "Transliteration",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Image.asset("assets/flowers/flower.png", height: 28),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.state.result?.transliteration ?? '',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 64),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/flowers/hibiscus.png", height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "Meaning",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Image.asset("assets/flowers/hibiscus.png", height: 24),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.state.result?.comments?[_selectedAuthor].languages?[_selectedLanguage]
                            .text ??
                        '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            );
          }

          return const Center(
            child: Text("Something went wrong"),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: BlocBuilder<VerseCubit, VerseState>(
        builder: (context, state) {
          if (state is VerseSuccess) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(44, 44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(54))),
                    onPressed: () {
                      if (widget.verseNo - 1 <= 0) {
                        return;
                      }

                      context.pushReplacementNamed(
                        AppRoutes.verse,
                        extra: {
                          "chapter_no": widget.chapterNo,
                          "verse_no": widget.verseNo - 1,
                        },
                      );
                    },
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        isScrollControlled: true,
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width,
                        ),
                        builder: (context) {
                          return OptionDrawer(
                            comments: state.state.result?.comments ?? [],
                            selectedAuthor: _selectedAuthor,
                            selectedLanguage: _selectedLanguage,
                            onOptionChange: (selectedAuthor, selectedLanguage) {
                              setState(() {
                                _selectedLanguage = selectedLanguage;
                                _selectedAuthor = selectedAuthor;
                              });
                            },
                          );
                        },
                      );
                    },
                    child: const Text("Options"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(44, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(54),
                      ),
                    ),
                    onPressed: () {
                      if (widget.verseNo + 1 > _chapter.verses!) {
                        return;
                      }

                      context.pushReplacementNamed(
                        AppRoutes.verse,
                        extra: {
                          "chapter_no": widget.chapterNo,
                          "verse_no": widget.verseNo + 1,
                        },
                      );
                    },
                    child: const Icon(Icons.keyboard_arrow_right),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

typedef OptionSelectCallback = void Function(int selectedAuthor, int selectedLanguage);

class OptionDrawer extends StatefulWidget {
  const OptionDrawer({
    super.key,
    required this.comments,
    required this.onOptionChange,
    required this.selectedAuthor,
    required this.selectedLanguage,
  });

  final List<Comments?> comments;
  final OptionSelectCallback onOptionChange;
  final int selectedAuthor;
  final int selectedLanguage;

  @override
  State<OptionDrawer> createState() => _OptionDrawerState();
}

class _OptionDrawerState extends State<OptionDrawer> {
  late int author;
  late int language;

  @override
  void initState() {
    author = widget.selectedAuthor;
    language = widget.selectedLanguage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Commentators",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: CoreColors.blackBean, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              widget.comments.length,
              (index) {
                final comment = widget.comments[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      author = index;
                      language = 0;
                    });
                    widget.onOptionChange(author, language);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: author == index ? CoreColors.brown : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.brown),
                    ),
                    child: Text(
                      comment?.author ?? '-',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: author == index ? CoreColors.mintCream : CoreColors.brown),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Comment Language",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: CoreColors.blackBean, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              widget.comments[author]?.languages?.length ?? 0,
              (index) {
                final comment = widget.comments[author]?.languages?[index];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      language = index;
                    });
                    widget.onOptionChange(author, language);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: language == index ? CoreColors.brown : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: CoreColors.brown),
                    ),
                    child: Text(
                      comment?.language ?? '-',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: language == index ? CoreColors.mintCream : CoreColors.brown),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
