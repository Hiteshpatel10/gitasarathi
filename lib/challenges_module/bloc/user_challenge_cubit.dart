import 'package:bloc/bloc.dart';
import 'package:chapter/challenges_module/model/user_challenge_and_challenges_model.dart';
import 'package:chapter/main.dart';
import 'package:chapter/utility/network/api_endpoints.dart';
import 'package:chapter/utility/network/dio_request_template.dart';
import 'package:meta/meta.dart';

part 'user_challenge_state.dart';

class UserChallengeCubit extends Cubit<UserChallengeState> {
  UserChallengeCubit() : super(UserChallengeInitial());

  getUserChallengesAndChallenges() async {
    emit(UserChallengeLoadingState());
    logger.d("UserChallengeCubit => getUserChallengesAndChallenges > Start");

    try {
      final response = await getRequest(apiEndPoint: ApiEndpoints.userChallenges);

      final model = UserChallengeAndChallengesModel.fromJson(response);

      emit(UserChallengeSuccessState(challenges: model));

      logger.d("UserChallengeCubit => getUserChallengesAndChallenges > Success");
    } catch (e) {
      emit(UserChallengeErrorState());
      logger.e("UserChallengeCubit => getUserChallengesAndChallenges > End with error\n$e");
    }
  }

  Future<dynamic> startChallenge({required num? challengeId}) async {
    logger.d("UserChallengeCubit => startChallenge > Start");
    if (challengeId == null) {
      throw "challenge_id cant be null";
    }
    try {
      final response = await postRequest(
        apiEndPoint: ApiEndpoints.userChallengesStart,
        postData: {"challenge_id": challengeId},
      );

      logger.d("UserChallengeCubit => startChallenge > Success");
      return response;
    } catch (e) {
      logger.e("UserChallengeCubit => startChallenge > End with error\n$e");
      return null;
    }
  }

  Future<dynamic> stopUserChallenge({required num? userChallengeId}) async {
    logger.d("UserChallengeCubit => stopUserChallenge > Start");
    if (userChallengeId == null) {
      throw "user_challenge_id cant be null";
    }
    try {
      final response = await postRequest(
        apiEndPoint: ApiEndpoints.userChallengesStop,
        postData: {"user_challenge_id": userChallengeId},
      );

      logger.d("UserChallengeCubit => stopUserChallenge > Success");
      return response;
    } catch (e) {
      logger.e("UserChallengeCubit => stopUserChallenge > End with error\n$e");
      return null;
    }
  }
}
