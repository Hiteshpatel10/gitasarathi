import 'package:chapter/chapter_module/bloc/chapters_and_verse_cubit.dart';
import 'package:chapter/chapter_module/model/chapter_model.dart';
import 'package:chapter/components/parallax_container.dart';
import 'package:chapter/components/push_button.dart';
import 'package:chapter/theme/core_colors.dart';
import 'package:chapter/utility/navigation/app_routes.dart';
import 'package:chapter/utility/network/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

import 'package:go_router/go_router.dart';

class ChapterDetailView extends StatefulWidget {
  const ChapterDetailView({super.key, required this.chapterNo});

  final int chapterNo;

  @override
  State<ChapterDetailView> createState() => _ChapterDetailViewState();
}

class _ChapterDetailViewState extends State<ChapterDetailView> {
  late final ScrollController scrollController;
  final double _gapHeight = 60;

  late final Chapters _chapter;

  @override
  void initState() {
    final chapterModel = ChapterModel.fromJson(chapterData);
    _chapter = chapterModel.chapters![widget.chapterNo];
    scrollController = ScrollController();
    scrollController.addListener(() => setState(() {}));

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        scrollController.animateTo((_chapter.verses ?? 0) * 80,
            duration: const Duration(seconds: 2), curve: Curves.easeIn);
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ChaptersAndVerseCubit, ChaptersAndVerseState>(
        builder: (context, state) {
          if (state is ChapterAndVerseSuccessState) {
            final model = state.chaptersAndVerse.result;

            // return SingleChildScrollView(
            //   controller: scrollController,
            //   child: Column(
            //     children: [
            //       ListView.builder(
            //         shrinkWrap: true,
            //         reverse: true,
            //         itemCount: _chapter.verses?.toInt() ?? 0,
            //         physics: const NeverScrollableScrollPhysics(),
            //         itemBuilder: (context, index) {
            //           final baseY = index * _gapHeight;

            //           return Transform.translate(
            //             offset: Offset(
            //               100 *
            //                   math.sin(
            //                       (scrollController.offset + index * _gapHeight + baseY) / 150),
            //               0,
            //             ),
            //             child: Padding(
            //               padding: const EdgeInsets.symmetric(vertical: 12),
            //               child: Center(
            //                 child: LevelAnimatedButton(
            //                   onPressed: () {
            //                     context.pushNamed(
            //                       AppRoutes.verse,
            //                       extra: {
            //                         "chapter_no": widget.chapterNo + 1,
            //                         "verse_no": index + 1,
            //                       },
            //                     );
            //                   },
            //                   height: 50,
            //                   buttonHeight: 10,
            //                   width: 65,
            //                   backgroundColor:
            //                       model?.reads?[widget.chapterNo].verses?.contains(index + 1) ==
            //                               true
            //                           ? CoreColors.butterScotch
            //                           : CoreColors.lavenderBlush,
            //                   buttonType: LevelButtonTypes.oval,
            //                   child: Text(
            //                     (index + 1).toString(),
            //                     style: Theme.of(context).textTheme.labelMedium,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           );
            //         },
            //       ),

            //       ParallaxContainer(
            //         imageUrl: '${ApiEndpoints.s3BaseURL}ch${widget.chapterNo + 1}.png',
            //         name: _chapter.title ?? '-',
            //         country: "Chapter ${widget.chapterNo + 1}",
            //         progress: model?.reads?[widget.chapterNo].progress,
            //       ),
            //     ],
            //   ),
            // );
          }

          if (state is ErrorState) {
            return Text("ere");
          }

          return Text("ere");
        },
      ),
    );
  }
}
