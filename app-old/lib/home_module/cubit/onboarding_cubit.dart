import 'package:bloc/bloc.dart';
import 'package:chapter/home_module/model/onboarding_model.dart';
import 'package:chapter/main.dart';
import 'package:chapter/utility/network/api_endpoints.dart';
import 'package:chapter/utility/network/dio_request_template.dart';
import 'package:chapter/utility/services/app_update_service.dart';
import 'package:meta/meta.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  void getOnboarding({bool checkUpdate = false}) async {
    emit(OnboardingLoadingState());
    logger.d("OnboardingCubit => getOnboarding > Start");

    try {
      final response = await getRequest(apiEndPoint: ApiEndpoints.onboarding);

      final model = OnboardingModel.fromJson(response);
      emit(OnboardingSuccessState(onboarding: model));
      if(checkUpdate)  appUpdateCheck(appUpdate: model.appUpdate);

      logger.d("OnboardingCubit => getOnboarding > Success");
    } catch (e) {
      emit(OnboardingErrorState(message: e.toString()));
      logger.e("OnboardingCubit => getOnboarding > End with error\n$e");
    }
  }
}
