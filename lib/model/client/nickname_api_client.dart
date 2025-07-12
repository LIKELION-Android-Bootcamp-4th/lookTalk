// import 'package:dio/dio.dart';
// import 'package:look_talk/model/entity/request/nickname_request.dart';
//
// import '../../core/network/api_result.dart';
// import '../../core/network/end_points/login_manager/auth_endpoints.dart';
// import '../entity/response/nickname_check_response.dart';
//
// // dio 를 이용해 닉네임 중복 확인 api 를 직접 호출
// class NicknameApiClient {
//   final Dio _dio;
//
//   NicknameApiClient(this._dio);
//
//   Future<ApiResult<NicknameCheckResponse>> checkNicknameAvailable(
//     NicknameCheckRequest request,
//   ) async {
//     final response = await _dio.get(
//       AuthEndpoints.nicknameCheck,
//       queryParameters: request.toQuery(),
//       options: Options(
//         validateStatus: (status){
//           return status != null && status >= 200 && status < 500;
//         }
//       )
//     );
//
//     return ApiResult.fromResponse(response, (json) => NicknameCheckResponse.fromJson(json as Map<String, dynamic>));
//   }
// }

import 'package:dio/dio.dart';

import '../../core/network/api_result.dart';
import '../../core/network/end_points/login_manager/auth_endpoints.dart';
import '../entity/request/nickname_request.dart';
import '../entity/response/nickname_check_response.dart';

class CheckNameApiClient {
  final Dio _dio;

  CheckNameApiClient(this._dio);

  // Future<ApiResult<CheckNameResponse>> checkDuplicate(CheckNameRequest request) async {
  //   final endpoint = _resolveEndpoint(request.type);
  //
  //   final response = await _dio.get(
  //     endpoint,
  //     queryParameters: request.toQuery(),
  //     options: Options(
  //       validateStatus: (status) =>
  //       status != null && status >= 200 && status < 500,
  //     ),
  //   );
  //
  //   // return ApiResult.fromResponse(
  //   //     response, (json) => CheckNameResponse.fromJson(json as Map<String, dynamic>));
  //   // return ApiResult.fromResponse(
  //   //   response,
  //   //       (rawJson) {
  //   //     if (rawJson is! Map<String, dynamic>) {
  //   //       throw Exception("Invalid response format.");
  //   //     }
  //   //
  //   //     final data = rawJson['data'];
  //   //     if (data is! Map<String, dynamic>) {
  //   //       throw Exception("Invalid or missing 'data' field in response.");
  //   //     }
  //   //
  //   //     return CheckNameResponse.fromJson(data);
  //   //   },
  //   // );
  //   return ApiResult.fromResponse(
  //     response,
  //         (rawJson) {
  //       if (rawJson is! Map<String, dynamic>) {
  //         throw Exception("Response is not a valid Map<String, dynamic>");
  //       }
  //
  //       final data = rawJson['data'];
  //       if (data == null || data is! Map<String, dynamic>) {
  //         throw Exception("Invalid or missing 'data' field in response.");
  //       }
  //
  //       return CheckNameResponse.fromJson(data);
  //     },
  //   );
  // }

  Future<ApiResult<CheckNameResponse>> checkDuplicate(CheckNameRequest request) async {
    final endpoint = _resolveEndpoint(request.type);

    final response = await _dio.get(
      endpoint,
      queryParameters: request.toQuery(),
      options: Options(
        validateStatus: (status) => status != null && status >= 200 && status < 500,
        responseType: ResponseType.json,
      ),
    );

    // 안전하게 Map으로 변환
    final rawJson = response.data;
    if (rawJson == null || rawJson is! Map<String, dynamic>) {
      throw Exception("Invalid response data type");
    }

    final data = rawJson['data'];
    if (data == null || data is! Map<String, dynamic>) {
      throw Exception("Invalid or missing 'data' field in response.");
    }

    return ApiResult.fromResponse(
      response,
          (json) {
        if (json == null || json is! Map<String, dynamic>) {
          throw Exception("Invalid or missing 'data' field in response.");
        }
        return CheckNameResponse.fromJson(json);
      },
    );
  }


  String _resolveEndpoint(CheckNameType type) {
    switch (type) {
      case CheckNameType.nickname:
        return AuthEndpoints.nicknameCheck;
      case CheckNameType.storeName:
        return AuthEndpoints.storeNameCheck;
    }
  }

}


