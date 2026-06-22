import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_endpoints.dart';
import '../services/pref_service.dart';
import '../constants/pref_keys.dart';

/// Provider for a configured Dio client
final dioProvider = Provider<Dio>((ref) {
  final prefs = ref.watch(prefServiceProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseURL,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  // Add interceptor for attaching auth token if available
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['device'] = Platform.isAndroid ? 'Android' : 'IOS';

        final token = prefs.getString(PrefKeys.userToken);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = token;
        }
        return handler.next(options);
      },
    ),
  );

  dio.interceptors.add(LogInterceptor(
    request: true,
    requestBody: true,
    responseBody: false,
    error: true,
  ));

  return dio;
});
