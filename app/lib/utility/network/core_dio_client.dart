import 'dart:io';
import 'package:chapter/main.dart';
import 'package:chapter/utility/network/api_endpoints.dart';
import 'package:chapter/utility/pref/app_pref_keys.dart';
import 'package:dio/dio.dart';

class CoreDioClient {
  Dio init() {
    Dio dio = Dio();

    var token = prefs.getString(AppPrefKeys.token);
    dio.options.headers["Authorization"] = token;
    dio.options.headers["device"] = Platform.isAndroid ? 'Android' : 'IOS';
    dio.options.baseUrl = ApiEndpoints.baseURL;

    // Add logging interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print("REQUEST URL: ${options.baseUrl}${options.path}");
        return handler.next(options);
      },
    ));

    return dio;
  }
}
