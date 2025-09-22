import 'package:chapter/chapter_module/bloc/chapters_and_verse_cubit.dart';
import 'package:chapter/components/app_error_widget.dart';
import 'package:chapter/components/push_button.dart';
import 'package:chapter/theme/core_colors.dart';
import 'package:chapter/user_module/cubit/user_cubit.dart';
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
  final double _gapHeight = 80;

  bool _isInteractionInserted = false;

  @override
  void initState() {
    super.initState();
    _chaptersAndVerseCubit = BlocProvider.of<ChaptersAndVerseCubit>(context);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
    _loadChapter();
  }

  int _lastReadIndex = 0;

  Future<void> _loadChapter() async {
    final chapter = await _chaptersAndVerseCubit.searchChapter(
      widget.chapterNo,
    );

    _updateUserInteractions(chapterId: chapter?.id);

    if (chapter != null) {
      final lastReadVerseIndex = chapter.verses?.lastIndexWhere((v) => v.isRead == true) ?? 0;
      _lastReadIndex = lastReadVerseIndex >= 0 ? lastReadVerseIndex : 0;
    }

    if (mounted) {
      setState(() => _selectedChapter = chapter);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final targetOffset = _lastReadIndex * _gapHeight;

        _scrollController.animateTo(
          targetOffset,
          duration: const Duration(seconds: 2),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _updateUserInteractions({num? chapterId, num? verseId}) {
    if (_isInteractionInserted == false) {
      BlocProvider.of<UserCubit>(context).insertUserActivity(
        chapterId: chapterId,
        verseId: verseId,
        activity: UserActivity.chapterOpen,
      );
      _isInteractionInserted = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chapter ${widget.chapterNo}"),
      ),
      body: BlocConsumer<ChaptersAndVerseCubit, ChaptersAndVerseState>(
        listener: (context, state) {
          if (state is ChapterAndVerseSuccessState) {
            _loadChapter();
          }
        },
        builder: (context, state) {
          if (state is ChapterAndVerseSuccessState) {
            return ListView.builder(
              reverse: true,
              controller: _scrollController,
              itemCount: _selectedChapter?.verses?.length ?? 0,
              itemBuilder: (context, index) {
                final baseY = index * _gapHeight;
                final verse = _selectedChapter?.verses?[index];

                return _buildVerseItem(
                  baseY: baseY,
                  index: index,
                  verseNo: verse?.verseNumber ?? (index + 1),
                  verseId: verse?.id,
                  isRead: verse?.isRead,
                );
              },
            );
          }

          if (state is ChapterAndVerseErrorState) {
            return const Center(
              child: AppErrorWidget(errorCode: AppErrorCode.serverError),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildVerseItem({
    required int index,
    required num verseNo,
    required double baseY,
    bool? isRead,
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
                AppRoutes.verseExplanation.name,
                pathParameters: {
                  "verseId": '$verseId',
                },
              );
            },
            height: 50,
            buttonHeight: 10,
            width: 65,
            backgroundColor: isRead == true ? CoreColors.butterScotch : CoreColors.lavenderBlush,
            buttonType: LevelButtonTypes.oval,
            child: Text(
              (index).toString(),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ),
      ),
    );
  }
}

