import 'package:chapter/main.dart';
import 'package:chapter/utility/pref/app_pref_keys.dart';
import 'package:uuid/uuid.dart';

class SessionService {
  init() {
    final sessionId = Uuid().v4();
    prefs.setString(AppPrefKeys.sessionId, sessionId);
  }

  Future<String> getOrCreateSessionId() async {
    String? sessionId = prefs.getString(AppPrefKeys.sessionId);
    if (sessionId == null) {
      sessionId = Uuid().v4();
      await prefs.setString(AppPrefKeys.sessionId, sessionId);
    }
    return sessionId;
  }
}
