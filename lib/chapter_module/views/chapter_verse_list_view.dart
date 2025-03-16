import 'package:chapter/chapter_module/bloc/chapters_and_verse_cubit.dart';
import 'package:chapter/components/push_button.dart';
import 'package:chapter/theme/core_colors.dart';
import 'package:chapter/utility/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:chapter/chapter_module/model/chapters_and_verse_model.dart'
    as chapter_and_verse_model;
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChapterVerseListView extends StatefulWidget {
  const ChapterVerseListView({
    super.key,
    required this.chapterNo,
  });

  final num chapterNo;

  @override
  State<ChapterVerseListView> createState() => _ChapterVerseListViewState();
}

class _ChapterVerseListViewState extends State<ChapterVerseListView> {
  late final ChaptersAndVerseCubit _chaptersAndVerseCubit;
  late final ScrollController _scrollController;

  chapter_and_verse_model.Result? _selectedChapter;
  final double _gapHeight = 60;

  @override
  void initState() {
    super.initState();
    _chaptersAndVerseCubit = BlocProvider.of<ChaptersAndVerseCubit>(context);
    _scrollController = ScrollController()..addListener(() => setState(() {}));
    _loadChapter();
  }

  Future<void> _loadChapter() async {
    final chapter = await _chaptersAndVerseCubit.searchChapter(
      widget.chapterNo,
    );
    if (mounted) {
      setState(() => _selectedChapter = chapter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              reverse: true,
              itemCount: _selectedChapter?.verses?.length ?? 0,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final baseY = index * _gapHeight;
                final verse = _selectedChapter?.verses?[index];

                return _buildVerseItem(
                  baseY: baseY,
                  index: index,
                  verseNo: verse?.verseNumber ?? (index + 1),
                  verseId: verse?.id,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerseItem({
    required int index,
    required num verseNo,
    required double baseY,
    num? verseId,
  }) {
    final offset = Offset(
        100 *
            math.sin(
              (_scrollController.offset + index * _gapHeight + baseY) / 150,
            ),
        0);
    return Transform.translate(
      offset: offset,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: LevelAnimatedButton(
            onPressed: () {
              GoRouter.of(context).pushNamed(
                AppRoutes.verseExplanation,
                extra: {
                  "verse_id": verseId,
                },
              );
              // context.pushNamed(
              //   AppRoutes.verse,
              //   extra: {
              //     "chapter_no": widget.chapterNo + 1,
              //     "verse_no": index + 1,
              //   },
              // );
            },
            height: 50,
            buttonHeight: 10,
            width: 65,
            backgroundColor:
                true ? CoreColors.butterScotch : CoreColors.lavenderBlush,
            buttonType: LevelButtonTypes.oval,
            child: Text(
              (index + 1).toString(),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ),
      ),
    );
  }
}
