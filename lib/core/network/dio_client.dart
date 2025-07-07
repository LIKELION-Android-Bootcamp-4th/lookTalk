import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'token_storage.dart';

// HTTP 요청 보내는 도구
class DioClient {
  static final TokenStorage _tokenStorage = TokenStorage();

  static final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: 'http://git.hansul.kr:3001',
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
              final accessToken = await _tokenStorage.getAccessToken();
              if (accessToken != null) {
                options.headers['Authorization'] = 'Bearer $accessToken';
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

                    // 새 토큰 저장
                    await _tokenStorage.saveTokens(
                      accessToken: newAccessToken,
                      refreshToken: newRefreshToken,
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
}
