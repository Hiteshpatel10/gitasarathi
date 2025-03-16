import 'package:bloc/bloc.dart';
import 'package:chapter/chapter_module/model/chapters_and_verse_model.dart';
import 'package:chapter/main.dart';
import 'package:chapter/utility/network/api_endpoints.dart';
import 'package:chapter/utility/network/dio_request_template.dart';
import 'package:chapter/utility/pref/app_pref_keys.dart';
import 'package:chapter/utility/pref/object_pref_keys.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'chapter_state.dart';

class ChaptersAndVerseCubit extends Cubit<ChaptersAndVerseState> {
  ChaptersAndVerseCubit() : super(ChapterInitial());

  getChaptersAndVerse() async {
    logger.d("ChapterCubit => getChaptersAndVerse > Start");
    final cache = ObjectPref.getData(
        AppPrefKeys.chaptersAndVerses, ChaptersAndVerseModel.fromJson);
    if (cache != null) {
      emit(ChapterAndVerseSuccessState(chaptersAndVerse: cache));
      return;
    }
    try {
      final response =
          await getRequest(apiEndPoint: ApiEndpoints.chaptersAndVerses);

      final model = ChaptersAndVerseModel.fromJson(response);
      emit(ChapterAndVerseSuccessState(chaptersAndVerse: model));
      ObjectPref.setData(AppPrefKeys.chaptersAndVerses, data: response);
      logger.d("ChapterCubit => getChaptersAndVerse > Success");
      return response;
    } catch (e) {
      emit(ErrorState());

      logger.e("ChapterCubit => getChaptersAndVerse > End with error\n$e");
    }
  }

  Future<Result?> searchChapter(num chapterNo) async {
    if (state is! ChapterAndVerseSuccessState) {
      await getChaptersAndVerse();
    }

    if (state is ChapterAndVerseSuccessState) {
      final currentState = state as ChapterAndVerseSuccessState;

      for (var chapter in currentState.chaptersAndVerse.result ?? []) {
        if (chapter.chapterNumber == chapterNo) {
          return chapter;
        }
      }
    }

    return null;
  }
}
