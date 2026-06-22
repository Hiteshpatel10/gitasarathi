import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_endpoints.dart';
import '../constants/pref_keys.dart';

/// Provider for a configured Dio client
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseURL,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  // Add interceptor for attaching auth token if available.
  // We read SharedPreferences fresh on every request so that a token
  // written right after login is always picked up (avoids stale snapshot).
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers['device'] = Platform.isAndroid ? 'Android' : 'IOS';

        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString(PrefKeys.userToken);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ),
  );

dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) {
    debugPrint('[→] ${options.method} ${options.uri}');
    return handler.next(options);
  },
  onResponse: (response, handler) {
    debugPrint('[←] ${response.statusCode} ${response.requestOptions.uri}');
    return handler.next(response);
  },
  onError: (error, handler) {
    debugPrint('[✗] ${error.response?.statusCode} ${error.requestOptions.uri} — ${error.message}');
    return handler.next(error);
  },
));

  return dio;
});
