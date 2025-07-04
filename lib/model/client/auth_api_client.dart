import 'package:dio/dio.dart';
import 'package:look_talk/core/network/dio_client.dart';
import 'package:look_talk/core/network/token_storage.dart';

import '../db/sns_login_result.dart';

class AuthApiClient {
  final Dio _dio = DioClient.instance;
  final TokenStorage _tokenStorage = TokenStorage();

  Future<SnsLoginResult> checkUserExists({
    required String email,
    required String provider,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/sns-login',
        data: {
          'email': email,
          'provider': provider,
        },
      );

      final data = response.data['data'];
      return SnsLoginResult.fromJson(data);
    } catch (e) {
      rethrow; // ViewModel에서 처리
    }
  }


  /// 로그인 요청
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final accessToken = response.data['accessToken'];
      final refreshToken = response.data['refreshToken'];

      if (accessToken != null && refreshToken != null) {
        await _tokenStorage.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('로그인 에러: $e');
      return false;
    }
  }

  /// 로그아웃 (토큰 삭제)
  Future<void> logout() async {
    await _tokenStorage.deleteTokens();
  }

  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/api/auth/refresh',
        data: {
          'refreshToken': refreshToken,
        },
      );

      final newAccessToken = response.data['accessToken'];
      final newRefreshToken = response.data['refreshToken'];

      if (newAccessToken != null && newRefreshToken != null) {
        await _tokenStorage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('토큰 갱신 실패: $e');
      return false;
    }
  }
}

