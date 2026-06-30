import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:app/core/network/api_endpoints.dart';
import 'package:app/core/network/dio_provider.dart';
import 'package:app/core/services/logger_service.dart';
import 'package:app/core/services/activity_service.dart';

final fcmServiceProvider = Provider<FcmService>((ref) {
  final dio = ref.watch(dioProvider);
  final logger = ref.watch(loggerProvider);
  final activityService = ref.watch(activityServiceProvider);
  return FcmService(dio, logger, activityService);
});

class FcmService {
  final Dio _dio;
  final LoggerService _logger;
  final ActivityService _activityService;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  FcmService(this._dio, this._logger, this._activityService);

  Future<void> init() async {
    // Request permissions
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Initialize Local Notifications for showing foreground messages
    const androidSettings = AndroidInitializationSettings('mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        try {
          if (details.payload != null && details.payload!.isNotEmpty) {
            final Map payload = json.decode(details.payload!);
            _onNotificationClicked(payload);
          }
        } catch (e, stack) {
          _logger.e("Local notification tap error: $e", e, stack);
        }
      },
    );

    // Listen to foreground FCM messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _logger.d("FcmService => Foreground Message: ${message.messageId}");
      _showLocalNotification(message);
    });

    // Handle when app is opened from a terminated state via notification
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _onNotificationClicked(initialMessage.data);
    }

    // Handle when app is opened from a background state via notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _logger.d("FcmService => Message Opened App: ${message.messageId}");
      _onNotificationClicked(message.data);
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      final title = message.notification?.title ?? "GitaSarathi";
      final body = message.notification?.body ?? "";
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const androidDetails = AndroidNotificationDetails(
        'fcm_channel',
        'FCM Notifications',
        importance: Importance.max,
        priority: Priority.high,
      );
      const iosDetails = DarwinNotificationDetails();
      const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

      await _localNotificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: details,
        payload: json.encode(message.data),
      );
    } catch (e, stack) {
      _logger.e("Error showing local notification: $e", e, stack);
    }
  }

  void _onNotificationClicked(Map payload) {
    _logger.d("FcmService => Notification Clicked payload: $payload");
    
    // Log activity
    _activityService.insertUserActivity(
      activity: "Notification Click",
    );
  }

  Future<void> updateFcmTokenOnServer() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token == null) {
        _logger.w("FcmService => FCM Token is null");
        return;
      }

      _logger.d("FcmService => Updating FCM Token on backend...");

      final response = await _dio.put(
        ApiEndpoints.updateFcmToken,
        data: {
          "fcm_token": token,
        },
      );

      _logger.d("FcmService => FCM Token Update Success: $response");
    } catch (e, stack) {
      _logger.e("FcmService => FCM Token Update Error: $e", e, stack);
    }
  }

  Future<void> clearFcmToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _logger.d("FcmService => Deleted FCM token");
    } catch (e, stack) {
      _logger.e("FcmService => Error deleting FCM token: $e", e, stack);
    }
  }
}
