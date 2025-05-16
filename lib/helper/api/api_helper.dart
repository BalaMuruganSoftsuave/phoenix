import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:phoenix/helper/enum_helper.dart';

class APIHelper {
  makeReq(String urlString, dynamic body,
      {Method method = Method.post,
      BodyType type = BodyType.json,
      bool isFile = false,
      String token = "",
      String accessToken = "",
      Map<String, String> header = const {},
      CancelToken? cancelToken}) async
  {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.other)) {
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
      } on DioException catch (e) {
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        if (e.type == DioExceptionType.cancel) {
          // Request was cancelled intentionally - return empty map instead of null
          debugLog("Request cancelled: ${e.message ?? ""}");
          throw ApiFailure(100, "Cancelled");
        }
        if (e.response != null) {
          debugLog(e.response.toString());
          debugLog(e.message ?? "");
          if(e.response.toString().isNotEmpty) {
            var body = jsonDecode(e.response.toString());
            var message = "";
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
            throw ApiFailure(e.response?.statusCode ?? 400, message);
          }else{
            throw ApiFailure(e.response?.statusCode ?? 400, "Failed to Load");
          }
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          debugLog("Request error: ${e.message ?? ""}");
          throw ApiFailure(e.response?.statusCode ?? 400, e.toString());
        }
      } catch (e) {
        makeLog(text: e.toString());
        throw ApiFailure(400, e.toString());
      }

      dynamic decodedJson;
      String? decodeError;
      String contentType = response.headers['content-type']?.first ?? '';
      
      // Check for HTML content in response
      if (contentType.contains('text/html') || 
          (response.data is String && (response.data as String).contains('<!DOCTYPE html>')) ||
          (response.data is String && (response.data as String).contains('<html'))) {
        debugLog("Received HTML response instead of JSON");
        throw ApiFailure(400, "Failed to load");
      }

      if (!isFile) {
        try {
          decodedJson = response.data;
        } catch (e) {
          decodeError = e.toString();
        }
      }

      makeLog(text: "Response: ${response.data.toString()}");

      if (decodeError != null) {
        throw ApiFailure(
            response.statusCode ?? 400, 'jsonDecode Error : $decodeError');
      }

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202 ||
          response.statusCode == 204 ||
          response.statusCode == 302) {
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
