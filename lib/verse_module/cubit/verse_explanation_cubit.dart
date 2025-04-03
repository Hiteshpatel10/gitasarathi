import 'package:bloc/bloc.dart';
import 'package:chapter/main.dart';
import 'package:chapter/utility/network/api_endpoints.dart';
import 'package:chapter/utility/network/dio_request_template.dart';
import 'package:chapter/utility/pref/app_pref_keys.dart';
import 'package:chapter/verse_module/model/verse_explanation_model.dart';
import 'package:meta/meta.dart';

part 'verse_explanation_state.dart';

class VerseExplanationCubit extends Cubit<VerseExplanationState> {
  VerseExplanationCubit() : super(VerseExplanationInitial());

  getVerseExplanation({num? verseId}) async {
    emit(VerseExplanationLoading());
    logger.d("VerseExplanationCubit => getVerseExplanation > Start");
    try {
      final response = await postRequest(
        apiEndPoint: ApiEndpoints.verseExplanation,
        postData: {
          "commentary_author_id": prefs.getInt(AppPrefKeys.authorId),
          "translation_author_id": prefs.getInt(AppPrefKeys.authorId),
          "verse_id": verseId
        },
      );

      logger.i(response);
      final model = VerseExplanationModel.fromJson(response);
      emit(VerseExplanationSuccess(verseExplanation: model));
      logger.d("VerseExplanationCubit => getVerseExplanation > Success");
      return response;
    } catch (e) {
      emit(VerseExplanationError(error: e.toString()));

      logger.e("VerseExplanationCubit => getVerseExplanation > End with error\n$e");
    }
  }
}
