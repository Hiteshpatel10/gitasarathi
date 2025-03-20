import 'package:bloc/bloc.dart';
import 'package:chapter/main.dart';
import 'package:chapter/user_module/model/user_model.dart';
import 'package:chapter/utility/network/api_endpoints.dart';
import 'package:chapter/utility/network/dio_request_template.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  Future<void> getUser() async {
    emit(UserLoadingState());
    logger.d("UserCubit => getUser > Start");

    try {
      final response = await getRequest(apiEndPoint: ApiEndpoints.user);

      final model = UserModel.fromJson(response);
      emit(UserSuccessState(user: model));

      logger.d("UserCubit => getUser > Success");
    } catch (e) {
      emit(UserErrorState());
      logger.e("UserCubit => getUser > End with error\n$e");
    }
  }

  insertUserRead({required num chapterNo, required num verseNo}) async {
    logger.d("UserCubit => insertUserRead > Start");

    try {
      final postData = {
        "chapter_no": chapterNo,
        "verse_no": verseNo,
      };
      final response = await postRequest(
        apiEndPoint: ApiEndpoints.insertUserRead,
        postData: postData,
      );

      logger.d("UserCubit => insertUserRead > Success");
      return response;
    } catch (e) {
      logger.e("UserCubit => insertUserRead > End with error\n$e");
    }
  }

  insertUserActivity({num? chapterNo, num? verseNo, required String activity}) async {
    logger.d("UserCubit => insertUserRead > Start");

    try {
      final postData = {
        "verse_no": verseNo,
        "chapter_no": chapterNo,
        "activity": activity,
      };
      final response = await postRequest(
        apiEndPoint: ApiEndpoints.insertUserActivity,
        postData: postData,
      );

      logger.d("UserCubit => insertUserActivity > Success $response");
      return response;
    } catch (e) {
      logger.e("UserCubit => insertUserActivity > End with error\n$e");
    }
  }
}

class UserActivity {
  static const chapterOpen = "Chapter Open";
  static const verseRead = "Verse Read";
}
