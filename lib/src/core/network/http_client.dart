import 'package:dio/dio.dart';

class HttpClient {
  HttpClient._();

  static final HttpClient instance = HttpClient._();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.placeholder.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    ),
  );

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? query,
    Options? options,
  }) {
    return _dio.get<T>(path, queryParameters: query, options: options);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
    Options? options,
  }) {
    return _dio.post<T>(path,
        data: data, queryParameters: query, options: options);
  }
}
