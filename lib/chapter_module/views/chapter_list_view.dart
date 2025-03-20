import 'package:chapter/chapter_module/bloc/chapters_and_verse_cubit.dart';
import 'package:chapter/components/app_error_widget.dart';
import 'package:chapter/components/parallax_container.dart';
import 'package:chapter/utility/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChapterListView extends StatelessWidget {
  const ChapterListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChaptersAndVerseCubit, ChaptersAndVerseState>(
      builder: (context, state) {
        if (state is ChapterAndVerseSuccessState) {
          final chaptersAndVerse = state.chaptersAndVerse;
          return ListView.builder(
            itemCount: chaptersAndVerse.result?.length ?? 0,
            itemBuilder: (context, index) {
              final chapter = chaptersAndVerse.result?[index];

              return GestureDetector(
                onTap: () {
                  GoRouter.of(context).pushNamed(
                    AppRoutes.chaptersVerse.name,
                    pathParameters: {
                      "chapter_no": '${chapter?.chapterNumber}',
                    },
                  );
                },
                child: ParallaxContainer(
                  imageUrl: chapter?.imageName ?? '',
                  name: chapter?.nameTranslation ?? '-',
                  progress: chapter?.progress,
                  country: "Chapter ${chapter?.chapterNumber}",
                ),
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
    );
  }
}
