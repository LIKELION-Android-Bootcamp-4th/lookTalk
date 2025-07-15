import 'package:dio/dio.dart';
import 'package:look_talk/core/network/api_result.dart';
import 'package:look_talk/core/network/end_points/community/community_endpoints.dart';
import 'package:look_talk/model/entity/response/post_create_response.dart';

import '../entity/request/post_create_request.dart';

import 'package:dio/dio.dart';
import 'package:look_talk/core/network/api_result.dart';
import 'package:look_talk/core/network/end_points/community/community_endpoints.dart';
import 'package:look_talk/model/entity/response/post_create_response.dart';
import '../entity/request/post_create_request.dart';

class PostCreateApiClient {
  final Dio _dio;

  PostCreateApiClient(this._dio);

  // Future<ApiResult<PostCreateResponse>> createPost({
  //   required PostCreateRequest request,
  // }) async {
  //   final formData = await request.toFormData();
  //
  //   try {
  //     final response = await _dio.post(
  //       CommunityEndpoints.writePost,
  //       data: formData,
  //       options: Options(
  //         headers: {
  //           'Content-Type': 'multipart/form-data',
  //           'X-Company-Code': '6866fcea5b230f5dc709bdeb'
  //         },
  //       ),
  //     );
  //
  //     print('[디버그] baseUrl: ${_dio.options.baseUrl}');
  //     print('[디버그] writePost: ${CommunityEndpoints.writePost}');
  //
  //     return ApiResult.fromResponse(
  //       response,
  //           (json) => PostCreateResponse.fromJson(json as Map<String, dynamic>),
  //     );
  //   } catch (e, stack) {
  //
  //
  //     if (e is DioException && e.response != null) {
  //       print('[서버 응답 코드]: ${e.response?.statusCode}');
  //       print('[서버 응답 본문]: ${e.response?.data}');
  //     } else {
  //       print('[에러] 예외 타입: ${e.runtimeType}');
  //       print('[에러 메시지]: $e');
  //     }
  //
  //     print('[에러] Dio 요청 실패: $e');
  //     print('[스택트레이스] $stack');
  //     print('[디버그] baseUrl: ${_dio.options.baseUrl}');
  //     print('[디버그] writePost: ${CommunityEndpoints.writePost}');
  //     print('[FormData 디버깅]');
  //     formData.fields.forEach((e) => print('Text field: ${e.key} = ${e.value}'));
  //     formData.files.forEach((e) => print('File field: ${e.key} = ${e.value.filename}'));
  //
  //     rethrow;
  //   }
  // }

  Future<ApiResult<PostCreateResponse>> createPost({
    required PostCreateRequest request,
  }) async {
    final bool hasImage = request.mainImage != null && request.mainImage!.isNotEmpty;

    try {
      final response = await _dio.post(
        CommunityEndpoints.writePost,
        data: hasImage ? await request.toFormData() : request.toJson(),
        options: Options(
          headers: {
            'Content-Type': hasImage ? 'multipart/form-data' : 'application/json',
            'X-Company-Code': '6866fcea5b230f5dc709bdeb',
          },
        ),
      );

      return ApiResult.fromResponse(
        response,
            (json) => PostCreateResponse.fromJson(json as Map<String, dynamic>),
      );
    } catch (e, stack) {
      // 디버그 출력 유지
      print('[에러] $e');
      rethrow;
    }
  }


}
