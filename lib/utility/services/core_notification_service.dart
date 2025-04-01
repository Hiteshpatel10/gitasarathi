import 'dart:convert';
import 'package:chapter/main.dart';
import 'package:chapter/utility/navigation/go_config.dart';
import 'package:chapter/utility/network/api_endpoints.dart';
import 'package:chapter/utility/network/dio_request_template.dart';
import 'package:chapter/utility/services/session_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CoreNotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  static final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> clearFCMToken() async {
    _firebaseMessaging.deleteToken();
  }

  Future<void> init({bool requestPermission = true}) async {
    if (requestPermission) await _firebaseMessaging.requestPermission();

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

    SessionService().getOrCreateSessionId().then(
      (sessionId) {
        final postData = {
          "verse_no": null,
          "chapter_no": null,
          "activity": "Notification Click",
          "session_id": sessionId,
        };
        postRequest(
          apiEndPoint: ApiEndpoints.insertUserActivity,
          postData: postData,
        );
      },
    );

    if (payload.containsKey('screen_path') == true) {
      goRouter.push(payload['screen_path']);
      return;
    }

    if (payload.containsKey('screen_name') == true) {
      if (payload.containsKey('path_parameters') == true) {
        final Map<String, dynamic> pathParameterDynamic = jsonDecode(payload['path_parameters']);
        final Map<String, String> pathParameters = pathParameterDynamic.map(
          (key, value) => MapEntry(key, value.toString()),
        );
        goRouter.pushNamed(payload['screen_name'], pathParameters: pathParameters);
        return;
      }
      goRouter.pushNamed(payload['screen_name']);
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
        'push_notification',
        'push_notification',
        importance: Importance.max,
        priority: Priority.high,
        // styleInformation: BigPictureStyleInformation(DrawableResourceAndroidBitmap('ic_notification'), largeIcon:  DrawableResourceAndroidBitmap('ic_notification')),
        largeIcon: DrawableResourceAndroidBitmap('mipmap/ic_notification'),
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

    await putRequest(
      apiEndPoint: ApiEndpoints.updateFcmToken,
      postData: {
        "fcm_token": fcmToken,
      },
    );
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
        CoreNotificationService().onNotificationClicked(
          payload: message.data,
          from: "_handleMessage=>onMessageOpenedApp",
        );
      },
    );
  }
}
