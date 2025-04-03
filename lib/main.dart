import 'dart:async';
import 'package:chapter/auth_module/bloc/auth_cubit.dart';
import 'package:chapter/chapter_module/bloc/chapters_and_verse_cubit.dart';
import 'package:chapter/favourite_module/cubit/favourite_cubit.dart';
import 'package:chapter/home_module/cubit/language_and_author_cubit.dart';
import 'package:chapter/home_module/cubit/onboarding_cubit.dart';
import 'package:chapter/theme/core_colors.dart';
import 'package:chapter/user_module/cubit/user_activity_cubit.dart';
import 'package:chapter/user_module/cubit/user_cubit.dart';
import 'package:chapter/utility/navigation/go_config.dart';
import 'package:chapter/utility/services/network_check_service.dart';
import 'package:chapter/verse_module/cubit/verse_explanation_cubit.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences prefs;
late Logger logger;
late final GlobalKey<NavigatorState> globalNavigatorKey;
late final GlobalKey<ScaffoldMessengerState> globalScaffoldMessengerKey;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  logger = Logger();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (kDebugMode) {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
  }

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  globalNavigatorKey = GlobalKey<NavigatorState>();
  globalScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? show;
  late final CoreConnectionCheckService _connectivityService;
  @override
  void initState() {
    super.initState();
    _connectivityService = CoreConnectionCheckService();
    _connectivityService.startListening(
      AppLifecycleState.resumed,
      onConnected: () {
        if (show == true) {
          setState(() {
            show = false;
          });
        }
      },
      onDisconnected: () {
        setState(() {
          show = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<UserActivityCubit>(create: (context) => UserActivityCubit()),
        BlocProvider<OnboardingCubit>(create: (context) => OnboardingCubit()..getOnboarding()),
        BlocProvider<LanguageAndAuthorCubit>(create: (context) => LanguageAndAuthorCubit()),
        BlocProvider<ChaptersAndVerseCubit>(
            create: (context) => ChaptersAndVerseCubit()..getChaptersAndVerse()),
        BlocProvider<VerseExplanationCubit>(create: (context) => VerseExplanationCubit()),
        BlocProvider<UserCubit>(create: (context) => UserCubit()),
        BlocProvider<FavouriteCubit>(create: (context) => FavouriteCubit()),
      ],
      child: MaterialApp.router(
        title: 'Gita Sarathi',
        scaffoldMessengerKey: globalScaffoldMessengerKey,
        builder: (context, child) {
          final boldText = MediaQuery.boldTextOf(context);

          final newMediaQueryData = MediaQuery.of(context).copyWith(
            boldText: boldText,
            textScaler: const TextScaler.linear(1.0),
          );

          return MediaQuery(
            data: newMediaQueryData,
            child: Stack(
              children: [
                child ?? const SizedBox(),
                Positioned(
                  bottom: kBottomNavigationBarHeight + 20,
                  child: AnimatedCrossFade(
                    duration: Durations.long2,
                    crossFadeState:
                        show == true ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    firstChild: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: CoreColors.whiteFrost,
                      ),
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      child: Row(
                        children: [
                          const Icon(Icons.wifi_off),
                          const SizedBox(width: 12),
                          Text(
                            "No Internet Connection",
                            style: Theme.of(context).textTheme.titleSmall,
                          )
                        ],
                      ),
                    ),
                    secondChild: SizedBox(width: MediaQuery.of(context).size.width, height: 0),
                  ),
                ),
              ],
            ),
          );
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: CoreColors.yellowishOrange),
          useMaterial3: true,
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        routerConfig: goRouter,
      ),
    );
  }
}
