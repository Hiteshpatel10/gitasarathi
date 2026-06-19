import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:app/core/services/logger_service.dart';
import 'package:app/core/network/api_endpoints.dart';

class AuthRepository {
  final LoggerService logger;
  final Dio dio;

  AuthRepository({required this.logger, required this.dio});

  /// One-time initialization of the GoogleSignIn singleton.
  /// Call this from main() after WidgetsFlutterBinding.ensureInitialized().
  static Future<void> initialize() async {
    await GoogleSignIn.instance.initialize();
  }

  /// Attempts to sign in the user via Google (v7 API) and authenticates with the backend.
  /// Returns the backend authentication token on success, null if canceled.
  Future<String?> signInWithGoogle() async {
    logger.d("AuthRepository => signInWithGoogle > Start");
    try {
      // Sign out first to always show the account picker
      await GoogleSignIn.instance.signOut();

      // v7: authenticate() replaces signIn()
      final account = await GoogleSignIn.instance.authenticate();

      logger.i("AuthRepository => signInWithGoogle > Google Success: ${account.email}. Calling backend...");

      // Call backend to exchange Google info for our server token
      final response = await dio.post(
        ApiEndpoints.authentication,
        data: {
          "email": account.email,
          "google_auth_id": account.id,
          "display_name": account.displayName ?? '',
          "display_image": account.photoUrl ?? ''
        },
      );

      final data = response.data;
      if (data == null || data['status'] == 0 || data['token'] == null) {
        throw Exception("Invalid token from backend");
      }

      final String backendToken = data['token'];
      logger.i("AuthRepository => signInWithGoogle > Backend Auth Success");
      return backendToken;
    } on Exception catch (e, stackTrace) {
      logger.w("AuthRepository => signInWithGoogle > Canceled or failed: $e", e, stackTrace);
      return null;
    }
  }

  /// Signs the user out of Google
  Future<void> signOut() async {
    logger.d("AuthRepository => signOut > Start");
    await GoogleSignIn.instance.signOut();
  }
}

