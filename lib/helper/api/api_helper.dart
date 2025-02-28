import 'package:dio/dio.dart';

class DioApiHelper {
  final Dio _dio;
  CancelToken? _cancelToken;

  DioApiHelper({Dio? dio}) : _dio = dio ?? Dio();

  /// Cancels the previous API request before making a new one
  void _cancelPreviousRequest() {
    _cancelToken?.cancel("Cancelled due to new request");
    _cancelToken = CancelToken();
  }

  /// Handles API errors gracefully
  void _handleApiError(DioException e) {
    if (CancelToken.isCancel(e)) {
      print("Request canceled: ${e.message}");
    } else if (e.response != null) {
      print("API Error [${e.response?.statusCode}]: ${e.response?.data}");
    } else {
      print("Network Error: ${e.message}");
    }
  }

  /// Generic GET request
  Future<Response?> get(
      String url, {
        Map<String, dynamic>? queryParams,
        Map<String, String>? headers,
      }) async {
    _cancelPreviousRequest();
    try {
      return await _dio.get(
        url,
        queryParameters: queryParams,
        options: Options(headers: headers),
        cancelToken: _cancelToken,
      );
    } on DioException catch (e) {
      _handleApiError(e);
    }
    return null;
  }

  /// Generic POST request
  Future<Response?> post(
      String url, {
        dynamic data,
        Map<String, String>? headers,
      }) async {
    _cancelPreviousRequest();
    try {
      return await _dio.post(
        url,
        data: data,
        options: Options(headers: headers),
        cancelToken: _cancelToken,
      );
    } on DioException catch (e) {
      _handleApiError(e);
    }
    return null;
  }

  /// Generic PUT request
  Future<Response?> put(
      String url, {
        dynamic data,
        Map<String, String>? headers,
      }) async {
    _cancelPreviousRequest();
    try {
      return await _dio.put(
        url,
        data: data,
        options: Options(headers: headers),
        cancelToken: _cancelToken,
      );
    } on DioException catch (e) {
      _handleApiError(e);
    }
    return null;
  }

  /// Generic PATCH request
  Future<Response?> patch(
      String url, {
        dynamic data,
        Map<String, String>? headers,
      }) async {
    _cancelPreviousRequest();
    try {
      return await _dio.patch(
        url,
        data: data,
        options: Options(headers: headers),
        cancelToken: _cancelToken,
      );
    } on DioException catch (e) {
      _handleApiError(e);
    }
    return null;
  }

  /// Generic DELETE request
  Future<Response?> delete(
      String url, {
        dynamic data,
        Map<String, String>? headers,
      }) async {
    _cancelPreviousRequest();
    try {
      return await _dio.delete(
        url,
        data: data,
        options: Options(headers: headers),
        cancelToken: _cancelToken,
      );
    } on DioException catch (e) {
      _handleApiError(e);
    }
    return null;
  }

  /// Cancels all ongoing requests
  void cancelRequests() {
    _cancelToken?.cancel("Request manually cancelled");
  }
}
