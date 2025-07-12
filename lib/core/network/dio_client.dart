import 'package:dio/dio.dart';
import 'package:look_talk/core/network/end_points/login_manager/auth_endpoints.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'token_storage.dart';

// HTTP 요청 보내는 도구
class DioClient {
  static final TokenStorage _tokenStorage = TokenStorage();

  static final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: 'http://git.hansul.kr:3000',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Content-Type': 'application/json',
              'X-Company-Code': '6866fcea5b230f5dc709bdeb',
            },
          ),
        )
        ..interceptors.addAll([
          InterceptorsWrapper(
            onRequest: (options, handler) async {

              print('DEBUG: Request Path: ${options.path}');

              final excludedPaths = [
                AuthEndpoints.socialLogin,
                AuthEndpoints.refresh,
              ];

              final isExcluded = excludedPaths.any((excluded) => options.path.startsWith(excluded));

              if (!isExcluded) {
                final accessToken = await _tokenStorage.getAccessToken();

                print('DEBUG: Access Token in Interceptor: $accessToken');
                if (accessToken != null) {
                  options.headers['Authorization'] = 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2ODcxM2ZlZDU1NThmNjRiNzI0Yjg5YzQiLCJjb21wYW55SWQiOiI2ODY2ZmNlYTViMjMwZjVkYzcwOWJkZWIiLCJpc0FkbWluIjpmYWxzZSwiaXNTdXBlckFkbWluIjpmYWxzZSwiaWF0IjoxNzUyMjU4MDQ3LCJleHAiOjE3NTIzNDQ0NDd9.4kTj5EehImWv5qHiX12_dbNPl7OS3sh8uA7PRGroEtk';
                }
              }

              return handler.next(options);
            },
            onError: (DioException error, handler) async {
              // access token 만료 시 401 에러
              if (error.response?.statusCode == 401) {
                final refreshToken = await _tokenStorage.getRefreshToken();
                if (refreshToken != null) {
                  try {
                    final refreshResponse = await _dio.post(
                      '/api/auth/refresh',
                      data: {'refreshToken': refreshToken},
                    );

                    final newAccessToken = refreshResponse.data['accessToken'];
                    final newRefreshToken =
                        refreshResponse.data['refreshToken'];
                    final userId = refreshResponse.data['id'];

                    // 새 토큰 저장
                    await _tokenStorage.saveTokens(
                      accessToken: newAccessToken,
                      refreshToken: newRefreshToken,
                      userId: userId
                    );



                    // 실패한 요청 복구 후 재시도
                    final opts = error.requestOptions;
                    opts.headers['Authorization'] = 'Bearer $newAccessToken';
                    final cloneResponse = await _dio.fetch(opts);
                    return handler.resolve(cloneResponse);
                  } catch (e) {
                    await _tokenStorage.deleteTokens(); // 재발급 실패 → 로그아웃
                  }
                }
              }
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

  // GET 요청 메서드
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  // POST 요청 메서드
  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  // PUT 요청 메서드
  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  // DELETE 요청 메서드
  Future<Response> delete(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.delete(path, queryParameters: queryParameters);
  }



}
