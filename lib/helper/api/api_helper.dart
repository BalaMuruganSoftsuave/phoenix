import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:phoenix/helper/api/api_constant.dart';
import 'package:phoenix/helper/enum_helper.dart';

class APIHelper {
  makeReq(String urlString, dynamic body,
      {Method method = Method.post,
      BodyType type = BodyType.json,
      bool isFile = false,
      String token = "",
      String accessToken = "",
      Map<String, String> header = const {},
      CancelToken? cancelToken}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
   
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      final dio = Dio();
      Uri url = Uri.parse(urlString);
      Response response;
      var headers = {
        'Content-Type': type == BodyType.urlencoded
            ? 'application/x-www-form-urlencoded'
            : 'application/json',
        ...header
      };
      if (token.isNotEmpty) {
        headers['Authorization'] = "Bearer $token";
      }
      try {
        makeLog(
            text:
                "API : ${method.toString()} url : $url \nrequest : ${body.toString()} ");
        Options options = Options(
          headers: headers,
          responseType: isFile ? ResponseType.bytes : ResponseType.json,
        );

        switch (method) {
          case Method.post:
            response = await dio.post(
              url.toString(),
              data: type == BodyType.urlencoded ? body : jsonEncode(body),
              options: options,
              cancelToken: cancelToken,
            );
            break;
          case Method.get:
            if (body != null &&
                body is Map &&
                body.isNotEmpty &&
                body is Map<String, dynamic>) {
              String queryString = Uri(queryParameters: body).query;
              url = Uri.parse("$urlString?$queryString");
            }
            response = await dio.get(
              url.toString(),
              options: options,
              cancelToken: cancelToken,
            );
            break;
          case Method.put:
            response = await dio.put(
              url.toString(),
              data: type == BodyType.urlencoded ? body : jsonEncode(body),
              options: options,
              cancelToken: cancelToken,
            );
            break;
          case Method.patch:
            response = await dio.patch(
              url.toString(),
              data: type == BodyType.urlencoded ? body : jsonEncode(body),
              options: options,
              cancelToken: cancelToken,
            );
            break;
          case Method.delete:
            response = await dio.delete(
              url.toString(),
              data: jsonEncode(body),
              options: options,
              cancelToken: cancelToken,
            );
            break;
          default:
            response = await dio.post(
              url.toString(),
              data: type == BodyType.urlencoded ? body : jsonEncode(body),
              options: options,
              cancelToken: cancelToken,
            );
        }
      } on SocketException catch (e) {
        print('Network error: ${e.message}');
        throw ApiFailure(400, "Network error");
      } on HttpException catch (e) {
        print('HTTP error: ${e.message}');
        throw ApiFailure(400, "Network error");
      } on FormatException catch (e) {
        print('Bad response format: ${e.message}');
        throw ApiFailure(400, "Failed to load");
      } on DioException catch (e) {
        // Additional Dio error types handling
        try {
          if (e.type == DioExceptionType.cancel) {
            debugLog("Request cancelled: ${e.message ?? ""}");
            throw ApiFailure(100, "Cancelled");
          } else if (e.type == DioExceptionType.connectionTimeout) {
            debugLog("Connection timed out. Please try again.");

            throw ApiFailure(400, "Connection timed out. Please try again.");
          } else if (e.response != null && e.response?.data != null) {
            var body;
            try {
              body = e.response?.data is String
                  ? jsonDecode(e.response?.data)
                  : e.response?.data;
            } catch (parseError) {
              body = null;
            }
            String message = "";
            if (body != null && body is Map) {
              if (body.containsKey("Errors") && body["Errors"].isNotEmpty) {
                message = body["Errors"]["message"];
              } else if (body.containsKey("message")) {
                message = body["error"] ?? body["message"];
              } else if (body.containsKey("error_description")) {
                message = body["error_description"];
              }
            }
            if (message.isEmpty) message = "Failed to load";
            throw ApiFailure(e.response?.statusCode ?? 400, message);
          } else {
            throw ApiFailure(e.response?.statusCode ?? 400, "Failed to load");
          }
        } catch (_) {
          if (e.response?.statusCode == null || e.response?.statusCode == 100) {
            throw ApiFailure(e.response?.statusCode ?? 100, "");
          } else {
            throw ApiFailure(e.response?.statusCode ?? 400, "Failed to load");
          }
        }
      } catch (e) {
        // Catches all FormatException, type errors, null pointer, etc.
        makeLog(text: e.toString());
        if (e is ApiFailure && (e.code == null || e.code == 100)) {
          throw ApiFailure(e.code ?? 100, "");
        } else {
          throw ApiFailure(400, "Failed to load");
        }
//         throw ApiFailure(400, "Failed to load");
      }

      dynamic decodedJson;
      String? decodeError;
      String contentType = response.headers['content-type']?.first ?? '';

      // Check for HTML content in response
      // Detect unexpected HTML response
      if (contentType.contains('text/html') ||
          (response.data is String &&
              (response.data as String).contains('<!DOCTYPE html>')) ||
          (response.data is String &&
              (response.data as String).contains('<html'))) {
        debugLog("Received HTML response instead of JSON");
        throw ApiFailure(400, "Failed to load");
      }

// Attempt to decode JSON or fallback on error
      try {
        if (!isFile) {
          // If string, try decoding; else keep as is (for Map or List)
          if (response.data is String) {
            decodedJson = jsonDecode(response.data);
          } else {
            decodedJson = response.data;
          }
        }
      } catch (e) {
        // Any decoding error is handled here
        debugLog("JSON decode error: $e");
        throw ApiFailure(response.statusCode ?? 400, "Failed to load");
      }

      makeLog(text: "Response: ${response.data.toString()}");

// Only these status codes are considered successful
      if ([200, 201, 202, 204, 302].contains(response.statusCode)) {
        if (isFile) {
          return response.data;
        } else {
          return decodedJson;
        }
      } else if (response.statusCode == 400) {
        String message = "";
        var body = decodedJson;
        if (body != null && body.containsKey("Errors")) {
          final errors = body["Errors"];
          if (errors.isNotEmpty) {
            message = errors["message"];
          }
        } else if (body != null && body.containsKey("message")) {
          if (body["message"] != null && body["error"] != null) {
            message = body["error"];
          } else {
            message = body["message"];
          }
        } else if (body != null && body.containsKey("error_description")) {
          message = body["error_description"];
        } else {
          message = body?.toString() ?? "error response body not found";
        }
        throw ApiFailure(response.statusCode ?? 400, message);
      } else {
        String message = "";
        var body = decodedJson;
        if (body != null && body.containsKey("Errors")) {
          final errors = body["Errors"];
          if (errors.isNotEmpty) {
            message = errors["message"];
          }
        } else if (body != null && body.containsKey("error_description")) {
          message = body["error_description"];
        } else {
          message = body?.toString() ?? "error response body not found";
        }
        throw ApiFailure(response.statusCode ?? 400, message);
      }
    } else {
      throw ApiFailure(501, "Please check your internet connection");
    }
  }
}

class ApiFailure implements Exception {
  final int code;
  final String message;

  ApiFailure(this.code, this.message);

  @override
  String toString() => 'ApiFailure(code: $code, message: $message)';
}

String log = "";

makeLog({String event = "api", String text = "", bool save = false}) {
  debugLog("$event : $text");
  log = "$log, $event : $text";
  if (log.length > 5000) {
    log = "";
  }
}

void debugLog(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}
