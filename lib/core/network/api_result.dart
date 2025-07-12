// class ApiResult<T> {
//   final T? data;
//   final String? errorMessage;
//   final bool isSuccess;
//
//   ApiResult.success(this.data)
//       : isSuccess = true,
//         errorMessage = null;
//
//   ApiResult.failure(this.errorMessage)
//       : isSuccess = false,
//         data = null;
//
//   // static constructor from Dio Response
//   static ApiResult<T> fromResponse<T>(
//       dynamic response,
//       T Function(Map<String, dynamic>) fromJson,
//       ) {
//     try {
//       final map = response.data as Map<String, dynamic>;
//       final success = map['success'] as bool? ?? false;
//
//       if (success) {
//         final dataMap = map['data'] as Map<String, dynamic>;
//         final data = fromJson(dataMap);
//         return ApiResult.success(data);
//       } else {
//         return ApiResult.failure(map['message'] ?? '알 수 없는 오류');
//       }
//     } catch (e) {
//       return ApiResult.failure('파싱 중 오류 발생: $e');
//     }
//   }
//
//   void when({
//     required Function(T data) success,
//     required Function(ApiResult<T> failure) error,
//   }) {
//     if (isSuccess && data != null) {
//       success(data!);
//     } else {
//       error(this);
//     }
//   }
// }


import 'package:dio/dio.dart';

class ApiResult<T> {
  final bool success;
  final String message;
  final T? data;
  final DateTime timestamp;
  final String? error;

  ApiResult({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
    this.error
  });

  factory ApiResult.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
    return ApiResult(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      timestamp: DateTime.parse(json['timestamp']),
      error: json['error']
    );
  }

  static ApiResult<T> fromResponse<T>(
      Response response,
      T Function(Object?) fromJsonT,
      ) {
    final data = response.data as Map<String, dynamic>;
    return ApiResult.fromJson(data, fromJsonT);
  }

  static ApiResult<void> fromVoidResponse(Response response) {
    final data = response.data as Map<String, dynamic>;
    return ApiResult<void>(
      success: data['success'],
      message: data['message'],
      data: null,
      timestamp: DateTime.parse(data['timestamp']),
      error: data['error'],
    );
  }
}
