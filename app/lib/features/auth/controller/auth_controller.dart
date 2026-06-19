import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/logger_service.dart';
import '../../../core/services/pref_service.dart';
import '../../../core/constants/pref_keys.dart';
import '../provider/auth_providers.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    // Initial state: idle (no loading, no error)
  }

  Future<void> loginWithGoogle() async {
    final logger = ref.read(loggerProvider);
    logger.d("AuthController => loginWithGoogle > Start");

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final backendToken = await repo.signInWithGoogle();

      if (backendToken != null) {
        logger.i("AuthController => loginWithGoogle > Saving backend token");

        final prefs = ref.read(prefServiceProvider);
        await prefs.setString(PrefKeys.userToken, backendToken);
        
        // TODO: Navigation to Home will happen here or in the UI layer
      }
    });
  }
}
