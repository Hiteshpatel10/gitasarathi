import 'package:bloc/bloc.dart';
import 'package:chapter/home_module/model/language_and_author_model.dart';
import 'package:chapter/main.dart';
import 'package:chapter/utility/network/api_endpoints.dart';
import 'package:chapter/utility/network/dio_request_template.dart';
import 'package:chapter/utility/pref/app_pref_keys.dart';
import 'package:chapter/utility/pref/object_pref_keys.dart';
import 'package:meta/meta.dart';

part 'language_and_author_state.dart';

class LanguageAndAuthorCubit extends Cubit<LanguageAndAuthorState> {
  LanguageAndAuthorCubit() : super(LanguageAndAuthorInitial());

  Future<void> getLanguageAndAuthor() async {
    logger.d("LanguageAndAuthorCubit => getLanguageAndAuthor > Start");
    final cache = ObjectPref.getData(
      AppPrefKeys.languageAndAuthors,
      LanguageAndAuthorModel.fromJson,
    );
    if (cache != null) {
      emit(LanguageAndAuthorSuccess(languageAndAuthors: cache));
      return;
    }
    try {
      final response = await getRequest(apiEndPoint: ApiEndpoints.languageAndAuthors);

      final model = LanguageAndAuthorModel.fromJson(response);
      emit(LanguageAndAuthorSuccess(languageAndAuthors: model));
      ObjectPref.setData(AppPrefKeys.languageAndAuthors, data: response);
      logger.d("LanguageAndAuthorCubit => getLanguageAndAuthor > Success");
    } catch (e) {
      emit(LanguageAndAuthorError(message: e.toString()));

      logger.e("LanguageAndAuthorCubit => getLanguageAndAuthor > End with error\n$e");
    }
  }
}
