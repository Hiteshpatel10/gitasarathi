import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:app/core/theme/app_theme.dart';
import 'package:app/core/theme/theme_provider.dart';
import 'package:app/core/theme/font_size_provider.dart';
import 'package:app/core/services/pref_service.dart';
import 'package:app/core/services/cache_service.dart';
import 'package:app/features/auth/repository/auth_repository.dart';
import 'package:app/core/router/app_router.dart';
import 'package:app/core/services/fcm_service.dart';
import 'package:app/core/services/analytics_service.dart';
import 'package:app/core/services/activity_service.dart';
import 'package:app/core/constants/pref_keys.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Set up Firebase background messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Set up Firebase Crashlytics & Analytics in debug/release mode
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
  } else {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  // Initialize Google Sign-In v7 singleton
  await AuthRepository.initialize();

  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      cacheServiceProvider.overrideWithValue(CacheService(prefs)),
    ],
  );

  // Initialize services
  await container.read(fcmServiceProvider).init();
  await container.read(analyticsServiceProvider).logAppOpen();

  // Log App Open activity and update FCM token if user is signed in
  final token = prefs.getString(PrefKeys.userToken);
  if (token != null && token.isNotEmpty) {
    container.read(activityServiceProvider).insertUserActivity(activity: UserActivity.appOpen);
    container.read(fcmServiceProvider).updateFcmTokenOnServer();
    final email = prefs.getString(PrefKeys.userEmail);
    if (email != null) {
      container.read(analyticsServiceProvider).setUserProperties(email);
      FirebaseCrashlytics.instance.setUserIdentifier(email);
    }
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final fontScale = ref.watch(fontSizeProvider.notifier).scaleFactor;
    // We also need to watch the provider itself so it rebuilds when changed
    ref.watch(fontSizeProvider);

    return MaterialApp.router(
      title: 'GitaSarathi',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: goRouter,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(fontScale),
          ),
          child: child!,
        );
      },
    );
  }
}
