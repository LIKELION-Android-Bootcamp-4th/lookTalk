import 'package:dio/dio.dart';
import 'package:look_talk/core/network/api_result.dart';
import 'package:look_talk/core/network/end_points/community/community_endpoints.dart';
import 'package:look_talk/model/entity/response/post_create_response.dart';

import '../entity/request/post_create_request.dart';

class PostCreateApiClient {
  final Dio _dio;

  PostCreateApiClient(this._dio);

  Future<ApiResult<PostCreateResponse>> createPost({
    required PostCreateRequest request,
  }) async {
    final response = await _dio.post(
      CommunityEndpoints.writePost,
      data: request.toJson(),
    );
    return ApiResult.fromResponse(
      response,
      (json) => PostCreateResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}
