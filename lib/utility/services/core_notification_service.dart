import 'dart:convert';
import 'package:chapter/main.dart';
import 'package:chapter/utility/navigation/go_config.dart';
import 'package:chapter/utility/network/api_endpoints.dart';
import 'package:chapter/utility/network/dio_request_template.dart';
import 'package:chapter/utility/pref/app_pref_keys.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CoreNotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  static final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> clearFCMToken() async {
    _firebaseMessaging.deleteToken();
  }

  Future<void> init() async {
    await _firebaseMessaging.requestPermission();

    const initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_notification');
    final initializationSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // ------- Android notification click handler
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        try {
          final Map payload = json.decode(details.payload ?? "");

          onNotificationClicked(payload: payload, from: "onDidReceiveNotificationResponse");
        } catch (e) {
          logger.e("onDidReceiveNotificationResponse error $e");
        }
      },
      // onDidReceiveBackgroundNotificationResponse: (details) {
      //   final payLoad = jsonDecode(details.payload ?? '');
      //
      //   onNotificationClicked(payload: payLoad);
      // },
    );
  }

  fcmListener({Function()? onTap}) {
    logger.i("Notification Recieved => fcmListener initialized");

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        logger.i("Notification Recieved => fcmListener > $message ");
        createNotification(message);
      },
    );
  }

  onNotificationClicked({required Map payload, required String from}) {
    logger.e(payload);
    if (payload.containsKey('screen') && payload.containsKey('arguments')) {
      final arguments = json.decode(payload['arguments']);

      if (arguments == null) {
        return;
      }

      goRouter.pushNamed(payload['screen'], pathParameters: arguments);
    } else if (payload.containsKey('screen') == true) {
      goRouter.pushNamed(payload['screen']);
    }
  }

  void _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    try {
      final Map? payLoadMap = json.decode(payload ?? "");

      if (payLoadMap == null) {
        throw "error";
      }
      onNotificationClicked(payload: payLoadMap, from: "_onDidReceiveLocalNotification");
    } catch (e) {
      logger.e("onDidReceiveNotificationResponse error $e");
    }
  }

  static void createNotification(RemoteMessage message) async {
    try {
      final title = message.notification?.title ?? "Default Title";
      final body = message.notification?.body ?? "Default Body";
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const androidNotificationDetails = AndroidNotificationDetails(
        'pushnotification',
        'pushnotification',
        importance: Importance.max,
        priority: Priority.high,
        // styleInformation: BigPictureStyleInformation(DrawableResourceAndroidBitmap('ic_notification'), largeIcon:  DrawableResourceAndroidBitmap('ic_notification')),
        largeIcon: DrawableResourceAndroidBitmap('mipmap/ic_launcher'),
      );

      const iosNotificationDetail = DarwinNotificationDetails();

      const notificationDetails = NotificationDetails(
        iOS: iosNotificationDetail,
        android: androidNotificationDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: json.encode(message.data),
      );
    } catch (error) {
      logger.e("Notification Create Error $error");
    }
  }

  Future<void> updateFCMToken() async {
    await _firebaseMessaging.requestPermission();

    final fcmToken = await _firebaseMessaging.getToken();

    if (fcmToken == null) {
      logger.e("----------  updateFCMTokenAPI Stopped FCM Token in NULL ----------");
      return;
    }

    final prefsFCM = prefs.getString(AppPrefKeys.fcmToken);

    if (prefsFCM == null || prefsFCM != fcmToken) {
      prefs.setString(AppPrefKeys.fcmToken, fcmToken);
      await putRequest(
        apiEndPoint: ApiEndpoints.updateFcmToken,
        postData: {
          "fcm_token": fcmToken,
        },
      );
    } else if (prefsFCM == fcmToken) {
      logger.i("----------  updateFCMTokenAPI Stopped Same FCM Token $fcmToken ----------");
      return;
    }
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      CoreNotificationService().onNotificationClicked(
        payload: initialMessage.data,
        from: "_handleMessage",
      );
    }

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        logger.i("Received message with data: ${message.data}");
        if (message.data.isNotEmpty) {
          CoreNotificationService().onNotificationClicked(
            payload: message.data,
            from: "_handleMessage=>onMessageOpenedApp",
          );
        } else {
          logger.w("Received message with no data");
        }
      },
    );
  }
}
