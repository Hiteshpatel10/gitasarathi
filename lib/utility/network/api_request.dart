import 'dart:convert';
import 'package:chapter/main.dart';
import 'package:chapter/utility/network/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>?> getRequest({required String apiEndPoint}) async {
  Map<String, dynamic>? responseBody;

  try {
    debugPrint("^^^^^^^^^^^^^^^^^^ $apiEndPoint getRequest Start ^^^^^^^^^^^^^^^^^^");

    var headers = {
      'Authorization': 'Bearer ${prefs.getString("email")}',
    };

    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseURL}$apiEndPoint'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw "error";
    }

    responseBody = json.decode(utf8.decode(response.bodyBytes));

    debugPrint("^^^^^^^^^^^^^^^^^^ $apiEndPoint getRequest End ^^^^^^^^^^^^^^^^^^");
  } catch (error) {
    debugPrint("Error in getRequest: $error");
    rethrow;
  }

  return responseBody;
}

Future<Map<String, dynamic>?> postRequest({
  required String apiEndPoint,
  required Map<String, dynamic> postData,
}) async {
 dynamic response;
  try {
    debugPrint(
        "~~~~~~~~~~~~~~~~~~~~ $apiEndPoint postRequest postData $postData ~~~~~~~~~~~~~~~~~~~~");

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${prefs.getString("email")}',
    };

     response = await http.post(
      Uri.parse("${ApiEndpoints.baseURL}$apiEndPoint/"),
      headers: headers,
      body: json.encode(postData),
    );

    if (response.statusCode != 200) {
      throw "error";
    }


    debugPrint("~~~~~~~~~~~~~~~~~~~~ $apiEndPoint postRequest End ~~~~~~~~~~~~~~~~~~~~");
  } catch (error) {
    debugPrint("Error in postRequest: $error");
    rethrow;
  }

  return response;
}
