import 'package:bloc/bloc.dart';
import 'package:chapter/main.dart';
import 'package:chapter/user_module/model/user_model.dart';
import 'package:chapter/utility/network/api_endpoints.dart';
import 'package:chapter/utility/network/dio_request_template.dart';
import 'package:chapter/utility/services/session_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
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
      FirebaseCrashlytics.instance.setUserIdentifier('${model.result?.id}');
      logger.d("UserCubit => getUser > Success");
    } catch (e) {
      emit(UserErrorState());
      logger.e("UserCubit => getUser > End with error\n$e");
    }
  }

  Future<void> insertUserRead({required num chapterNo, required num verseNo}) async {
    if (kDebugMode) {
      logger.i("UserCubit => insertUserRead > Stopped (Debug Mode)");
      return;
    }
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

  Future<void> insertUserActivity({
    num? chapterId,
    num? verseId,
    required String activity,
  }) async {
    if (kDebugMode) {
      logger.i("UserCubit => insertUserActivity > Stopped (Debug Mode)");
      return;
    }

    logger.d("UserCubit => insertUserActivity > Start");

    try {
      final sessionId = await SessionService().getOrCreateSessionId();
      final postData = {
        "verse_no": verseId,
        "chapter_no": chapterId,
        "activity": activity,
        "session_id": sessionId,
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
  static const appOpen = "App Open";
  static const rateNow = "Rate Now";
  static const rateLater = "Rate Later";
  static const rateNo = "Rate No";
  static const share = "Share";
}
