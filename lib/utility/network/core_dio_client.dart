import 'dart:io';
import 'package:chapter/main.dart';
import 'package:chapter/utility/network/api_endpoints.dart';
import 'package:chapter/utility/pref/app_pref_keys.dart';
import 'package:dio/dio.dart';

class CoreDioClient {
  Dio init() {
    Dio dio = Dio();

    // final prefs = GetStorage();
    //
    var token = prefs.getString(AppPrefKeys.token);
    dio.options.headers["Authorization"] = token;
    dio.options.headers["device"] = Platform.isAndroid ? 'Android' : 'IOS';
    dio.options.baseUrl = ApiEndpoints.baseURL;

    return dio;
  }
}
