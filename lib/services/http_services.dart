import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tlbilling/api_service/app_url.dart';
import 'package:tlbilling/services/auth_services.dart';
import 'package:tlbilling/services/local_storage.dart';

class HttpServices {
  String host = AppUrl.baseUrl;
  BaseOptions? baseOptions;
  Dio? dio;
  SharedPreferences? prefs;

  HttpServices() {
    LocalStorageService.getPrefs();

    baseOptions = BaseOptions(
      baseUrl: host,
      validateStatus: (status) {
        return status != null && status <= 500;
      },
      // connectTimeout: 300,
    );
    dio = Dio(baseOptions);
  }

  Future<Map<String, String>> getHeaders() async {
    final userToken = await AuthServices.getAuthBearerToken();
    return {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $userToken",
    };
  }

  // For GET API calls
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    bool includeHeaders = true,
  }) async {
    // Preparing the API URI/URL
    String uri = "$host$url";

    // Preparing the GET options if headers are required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    Response response;

    try {
      response = await dio!.get(
        uri,
        options: mOptions,
        queryParameters: queryParameters,
      );
    } on DioException catch (error) {
      response = formatDioException(error);
    }

    return response;
  }

  // For POST API calls
  Future<Response> post(
    String url,
    body, {
    bool includeHeaders = true,
  }) async {
    // Preparing the API URI/URL
    String uri = "$host$url";

    // Preparing the POST options if headers are required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    Response response;
    try {
      response = await dio!.post(
        uri,
        data: body,
        options: mOptions,
      );
    } on DioException catch (error) {
      response = formatDioException(error);
    }

    return response;
  }

  // For POST API calls with file upload
  Future<Response> postWithFiles(
    String url,
    body, {
    bool includeHeaders = true,
  }) async {
    // Preparing the API URI/URL
    String uri = "$host$url";
    // Preparing the POST options if headers are required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    Response response;
    try {
      response = await dio!.post(
        uri,
        data: body is FormData ? body : FormData.fromMap(body),
        options: mOptions,
      );
    } on DioException catch (error) {
      response = formatDioException(error);
    }

    return response;
  }

  // For PATCH API calls
  Future<Response> patch(String url, Map<String, dynamic> body) async {
    String uri = "$host$url";
    Response response;

    try {
      response = await dio!.patch(
        uri,
        data: body,
        options: Options(
          headers: await getHeaders(),
        ),
      );
    } on DioException catch (error) {
      response = formatDioException(error);
    }

    return response;
  }

  // For DELETE API calls
  Future<Response> delete(String url) async {
    String uri = "$host$url";

    Response response;
    try {
      response = await dio!.delete(
        uri,
        options: Options(
          headers: await getHeaders(),
        ),
      );
    } on DioException catch (error) {
      response = formatDioException(error);
    }
    return response;
  }

  Response formatDioException(DioException ex) {
    var response = Response(requestOptions: ex.requestOptions);
    response.statusCode = 400;
    String? msg = response.statusMessage;

    try {
      if (ex.type == DioExceptionType.connectionTimeout) {
        msg =
            "Connection timeout. Please check your internet connection and try again";
      } else if (ex.type == DioExceptionType.sendTimeout) {
        msg = "Timeout. Please check your internet connection and try again";
      } else if (ex.type == DioExceptionType.receiveTimeout) {
        msg = "Timeout. Please check your internet connection and try again";
      } else if (ex.type == DioExceptionType.badResponse) {
        msg =
            "Received an invalid response. Please check your internet connection and try again";
      } else {
        msg = "Please check your internet connection and try again";
      }
      response.data = {"message": msg};
    } catch (error) {
      response.statusCode = 400;
      msg = "Please check your internet connection and try again";
      response.data = {"message": msg};
    }

    throw msg;
  }
}
