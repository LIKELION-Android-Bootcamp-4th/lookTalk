import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'token_storage.dart';

class DioClient {
  static final TokenStorage _tokenStorage = TokenStorage();

  static final Dio _dio =
  Dio(
    BaseOptions(
      baseUrl: 'http://git.hansul.kr:3000',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'X-Company-Code': '6866fcea5b230f5dc709bdeb',
      },
    ),
  )
    ..interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          const String adminTestToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2ODY5MTRiOTUzZmM4NTdjOGVjYTNhMjMiLCJjb21wYW55SWQiOiI2ODY2ZmNlYTViMjMwZjVkYzcwOWJkZWIiLCJpc0FkbWluIjp0cnVlLCJpc1N1cGVyQWRtaW4iOnRydWUsImlhdCI6MTc1MTkzNzkyMiwiZXhwIjoxNzUyMDI0MzIyfQ.s-H3cDcnjDEndB_xDWAkqtMRuCFgwbgbcSpHL_PHZKs';

          options.headers['Authorization'] = 'Bearer $adminTestToken';

          if (options.data is! FormData) {
            options.headers['Content-Type'] = 'application/json';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          return handler.next(error);
        },
      ),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        compact: true,
        maxWidth: 90,
      ),
    ]);

  static Dio get instance => _dio;

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.delete(path, queryParameters: queryParameters);
  }
}
