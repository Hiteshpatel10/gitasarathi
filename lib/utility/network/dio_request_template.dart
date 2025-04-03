import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'core_dio_client.dart';

Future<dynamic> getRequest({
  required String apiEndPoint,
}) async {
  Dio client = CoreDioClient().init();

  Response? response;
  try {
    debugPrint("^^^^^^^^^^^^^^^^^^ $apiEndPoint getRequest Start ^^^^^^^^^^^^^^^^^^");

    response = await client.get(apiEndPoint);

    debugPrint("^^^^^^^^^^^^^^^^^^ $apiEndPoint getRequest End ^^^^^^^^^^^^^^^^^^");

    if (response.statusCode != 200) {
      throw DioError(
        requestOptions: RequestOptions(path: apiEndPoint),
        response: response,
      );
    }
  } on DioError catch (dioError) {
    debugPrint("Error in getRequest: Failed to call api $apiEndPoint ${dioError.message}");
    rethrow;
  } catch (error) {
    debugPrint("Error in getRequest: $apiEndPoint $error");
    rethrow;
  }

  return response.data;
}

Future<dynamic> postRequest({
  required String apiEndPoint,
  required Map<String, dynamic> postData,
}) async {
  Dio client = CoreDioClient().init();
  Response? response;

  try {
    debugPrint(
        "~~~~~~~~~~~~~~~~~~~~ $apiEndPoint postRequest Start $postData ~~~~~~~~~~~~~~~~~~~~ ");

    response = await client.post(apiEndPoint, data: postData);

    if (response.statusCode != 200) {
      throw DioError(
        requestOptions: RequestOptions(path: apiEndPoint),
      );
    }

    debugPrint("~~~~~~~~~~~~~~~~~~~~ $apiEndPoint postRequest End ~~~~~~~~~~~~~~~~~~~~ ");
  } on DioError catch (dioError) {
    debugPrint("Error in getRequest: Failed to call api ${dioError.message}");
    rethrow;
  } catch (error) {
    debugPrint("Error in getRequest:");
    rethrow;
  }

  return response.data;
}

Future<dynamic> putRequest({
  required String apiEndPoint,
  required Map<String, dynamic> postData,
}) async {
  Dio client = CoreDioClient().init();
  Response? response;

  try {
    debugPrint(
        "~~~~~~~~~~~~~~~~~~~~ $apiEndPoint putRequest Start $postData ~~~~~~~~~~~~~~~~~~~~ ");

    response = await client.put(apiEndPoint, data: postData);

    if (response.statusCode != 200) {
      throw DioError(
        requestOptions: RequestOptions(path: apiEndPoint),
      );
    }

    debugPrint("~~~~~~~~~~~~~~~~~~~~ $apiEndPoint putRequest End ~~~~~~~~~~~~~~~~~~~~ ");
  } on DioError catch (dioError) {
    debugPrint("Error in putRequest: Failed to call api ${dioError.message}");
    rethrow;
  } catch (error) {
    debugPrint("Error in putRequest:");
    rethrow;
  }

  return response.data;
}

enum HttpMethod { post, put, delete }

Future<dynamic> sendRequest({
  required String apiEndPoint,
  required Map<String, dynamic> data,
  required HttpMethod method,
}) async {
  Dio client = CoreDioClient().init();
  Response? response;

  try {
    debugPrint(
        "~~~~~~~~~~~~~~~~~~~~ $apiEndPoint ${method.name} Request Start $data ~~~~~~~~~~~~~~~~~~~~ ");

    switch (method) {
      case HttpMethod.post:
        response = await client.post(apiEndPoint, data: data);
        break;
      case HttpMethod.put:
        response = await client.put(apiEndPoint, data: data);
        break;
      case HttpMethod.delete:
        response = await client.delete(apiEndPoint, data: data);
        break;
    }

    if (response.statusCode != 200) {
      throw DioError(requestOptions: RequestOptions(path: apiEndPoint));
    }

    debugPrint(
        "~~~~~~~~~~~~~~~~~~~~ $apiEndPoint ${method.name} Request End ~~~~~~~~~~~~~~~~~~~~ ");
  } on DioError catch (dioError) {
    debugPrint("Error in ${method.name} request: Failed to call API ${dioError.message}");
    rethrow;
  } catch (error) {
    debugPrint("Error in ${method.name} request:");
    rethrow;
  }

  return response.data;
}
