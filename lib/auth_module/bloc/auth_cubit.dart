import 'package:bloc/bloc.dart';
import 'package:chapter/main.dart';
import 'package:chapter/utility/network/api_endpoints.dart';
import 'package:chapter/utility/network/dio_request_template.dart';
import 'package:chapter/utility/pref/app_pref_keys.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  signInUser() async {
    logger.d("AuthCubit => signInUser > Start");
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();

      googleSignIn.signOut();
      final oAuthResponse = await googleSignIn.signIn();
      if (oAuthResponse == null) {
        throw "Google AUth Failed";
      }

      final response = await postRequest(
        apiEndPoint: ApiEndpoints.authentication,
        postData: {
          "email": oAuthResponse.email,
          "google_auth_id": oAuthResponse.id,
          "display_name": oAuthResponse.displayName,
        },
      );

      if (response?['token'] == null) {
        throw "Invalid token";
      }
      emit(AuthSuccess(token: response?['token']));
      logger.d("AuthCubit => signInUser > Success");
      return response;
    } catch (e) {
      emit(AuthFailed(errorMessage: "Failed to sign in user"));

      logger.e("AuthCubit => signInUser > End with error\n$e");
    }
  }
}
