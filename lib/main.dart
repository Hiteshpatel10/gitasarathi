import 'package:chapter/auth_module/bloc/auth_cubit.dart';
import 'package:chapter/chapter_module/bloc/chapters_and_verse_cubit.dart';
import 'package:chapter/chapter_module/bloc/user_activity_cubit.dart';
import 'package:chapter/home_module/cubit/language_and_author_cubit.dart';
import 'package:chapter/theme/core_colors.dart';
import 'package:chapter/utility/navigation/go_config.dart';
import 'package:chapter/utility/services/core_notification_service.dart';
import 'package:chapter/verse_module/bloc/verse_cubit.dart';
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
  //
  // if (message.data.isNotEmpty) {
  //   // Handle background notification data
  // }
}

void _handleMessage(RemoteMessage message) {
  logger.i("Received message with data: ${message.data}");
  if (message.data.isNotEmpty) {
    CoreNotificationService().onNotificationClicked(payload: message.data, from: "_handleMessage");
  } else {
    logger.w("Received message with no data");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  logger = Logger();

  await CoreNotificationService().init();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (kDebugMode) {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
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
  @override
  void initState() {
    setupInteractedMessage();

    CoreNotificationService().fcmListener();

    super.initState();
  }

  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      logger.i("Received message with data: ${message.data}");
      if (message.data.isNotEmpty) {
        CoreNotificationService().onNotificationClicked(payload: message.data, from: "_handleMessage=>onMessageOpenedApp");
      } else {
        logger.w("Received message with no data");
      }
    },);
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VerseCubit>(create: (context) => VerseCubit()),
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<LanguageAndAuthorCubit>(create: (context) => LanguageAndAuthorCubit()),
        BlocProvider<ChaptersAndVerseCubit>(create: (context) => ChaptersAndVerseCubit()..getChaptersAndVerse()),
        BlocProvider<UserActivityCubit>(create: (context) => UserActivityCubit()),
      ],
      child: MaterialApp.router(
        title: 'Gita Sarathi',
        scaffoldMessengerKey: globalScaffoldMessengerKey,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: CoreColors.yellowishOrange),
          useMaterial3: true,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        routerConfig: goConfig,
      ),
    );
  }
}
