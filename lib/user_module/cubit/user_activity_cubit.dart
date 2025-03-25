import 'package:bloc/bloc.dart';
import 'package:chapter/main.dart';
import 'package:chapter/user_module/model/user_activity_model.dart';
import 'package:chapter/utility/network/api_endpoints.dart';
import 'package:chapter/utility/network/dio_request_template.dart';
import 'package:meta/meta.dart';

part 'user_activity_state.dart';

class UserActivityCubit extends Cubit<UserActivityState> {
  UserActivityCubit() : super(UserActivityInitial());

  Future<void> getMonthlyUserActivity({required num month, required num year}) async {
    emit(UserActivityLoadingState());
    logger.d("UserCubit => getUser > Start");

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

      logger.d("UserCubit => getUser > Success");
    } catch (e) {
      emit(UserActivityErrorState());
      logger.e("UserCubit => getUser > End with error\n$e");
    }
  }
}
