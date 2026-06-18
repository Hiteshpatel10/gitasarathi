import 'package:bloc/bloc.dart';
import 'package:chapter/main.dart';
import 'package:chapter/user_module/model/user_activity_model.dart';
import 'package:chapter/utility/network/api_endpoints.dart';
import 'package:chapter/utility/network/dio_request_template.dart';
import 'package:meta/meta.dart';

part 'user_activity_state.dart';

class UserActivityCubit extends Cubit<UserActivityState> {
  UserActivityCubit() : super(UserActivityInitial());

  bool isStateDirty = true;

  Future<void> getMonthlyUserActivity({
    required num month,
    required num year,
  }) async {
    if (isStateDirty == false) {
      logger.d("UserCubit => getMonthlyUserActivity > Stopped (Clean State)R");
      return;
    }
    emit(UserActivityLoadingState());
    logger.d("UserCubit => getMonthlyUserActivity > Start");

    try {
      final postData = {
        "month": month,
        "year": year,
      };

      final response = await postRequest(
        apiEndPoint: ApiEndpoints.monthlyUserRead,
        postData: postData,
      );

      final model = UserActivityModel.fromJson(response);
      emit(UserActivitySuccessState(userActivity: model));
      isStateDirty = false;
      logger.d("UserCubit => getMonthlyUserActivity > Success");
    } catch (e) {
      emit(UserActivityErrorState());
      logger.e("UserCubit => getMonthlyUserActivity > End with error\n$e");
    }
  }

  Future<num?> checkStreakChange({
    required num month,
    required num year,
  }) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final streakKey = 'streak_${month}_$year';
    final checkKey = 'streak_check_${month}_$year';

    final lastCheckString = prefs.getString(checkKey);
    final lastCheckDate = lastCheckString != null ? DateTime.tryParse(lastCheckString) : null;

    if (lastCheckDate != null && lastCheckDate.isAtSameMomentAs(today)) {
      logger.d("Streak already checked today for $month/$year. Skipping...");
      return null;
    }

    await getMonthlyUserActivity(month: month, year: year);

    if (state is UserActivitySuccessState) {
      final activity = (state as UserActivitySuccessState).userActivity;
      final currentStreak = activity.streak ?? 0;

      final savedStreak = prefs.getInt(streakKey) ?? 0;

      if (currentStreak != savedStreak) {
        logger.i("🎉 Streak changed ($month/$year): $savedStreak → $currentStreak");
        prefs.setInt(streakKey, currentStreak.toInt());
      } else {
        logger.d("No change in streak ($month/$year). Current streak: $currentStreak");
      }

      prefs.setString(checkKey, today.toIso8601String());

      if (currentStreak > savedStreak) {
        return currentStreak;
      }
    }

    return null;
  }
}
