import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:phoenix/helper/enum_helper.dart';


class APIHelper {
  makeReq(String urlString, dynamic body,
      {Method method = Method.post,
      BodyType type = BodyType.json,
      bool isFile = false,
      String token = "",
      String accessToken = "",
      Map<String, String> header = const {}}) async {
    final https = Client();
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
      switch (method) {
        case Method.post:
          response = await https.post(url,
              headers: headers,
              body: type == BodyType.urlencoded ? body : jsonEncode(body),
              encoding: Encoding.getByName("utf-8"));
          break;
        case Method.get:
          if (body != null &&
              body is Map &&
              body.isNotEmpty &&
              body is Map<String, dynamic>) {
            String queryString = Uri(queryParameters: body).query;
            url = Uri.parse("$urlString?$queryString");
          }
          response = await https.get(url, headers: headers);
          break;
        case Method.put:
          response = await https.put(url,
              headers: headers,
              body: type == BodyType.urlencoded ? body : jsonEncode(body),
              encoding: Encoding.getByName("utf-8"));
          break;
        case Method.patch:
          response = await https.patch(url,
              headers: headers,
              body: type == BodyType.urlencoded ? body : jsonEncode(body),
              encoding: Encoding.getByName("utf-8"));
          break;
        case Method.delete:
          response = await https.delete(url,
              headers: headers,
              body: jsonEncode(body),
              encoding: Encoding.getByName("utf-8"));
          break;
        default:
          response = await https.post(url,
              headers: headers,
              body: type == BodyType.urlencoded ? body : jsonEncode(body),
              encoding: Encoding.getByName("utf-8"));
      }
    } catch (e) {
      makeLog(text: e.toString());
      throw ApiFailure(400, e.toString());
    }
    dynamic decodedJson;
    String? decodeError;

    if (!isFile) {
      try {
        decodedJson = jsonDecode(response.body);
      } catch (e) {
        decodeError = e.toString();
      }
    }
    makeLog(text: "Response: ${response.body.toString()}");

    if (decodeError != null) {
      throw ApiFailure(response.statusCode, 'jsonDecode Error : $decodeError');
    } //TODO: remove after development (when response.statusCode == 302 is fixed)
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202 ||
        response.statusCode == 204 ||
        response.statusCode == 302) {
      if (isFile) {
        return response.bodyBytes;
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
      } else if (body != null && body.containsKey("error_description")) {
        message = body["error_description"];
      } else {
        message = body?.toString() ?? "error response body not found";
      }
      throw ApiFailure(response.statusCode, message);
    }
    // else if (response.statusCode == 401) {
    //   // customToast(
    //   //     status: ToastStatusEnum.error,
    //   //     message: "Session Expired please login again");
    //   // logoutAndClearData(getCtx()!);
    //
    // }
    else {
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
      throw ApiFailure(response.statusCode, message);
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
