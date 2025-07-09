import 'package:dio/dio.dart';
import 'package:look_talk/core/network/api_result.dart';
import 'package:look_talk/core/network/end_points/community/community_endpoints.dart';
import 'package:look_talk/model/entity/request/post_list_request.dart';
import 'package:look_talk/model/entity/response/post_response.dart';
import 'package:look_talk/ui/common/component/community/post_list.dart';

import '../entity/response/post_list_response.dart';

class PostApiClient {
  final Dio _dio;

  PostApiClient(this._dio);

  Future<ApiResult<PostResponse>> fetchPost({required String id}) async {
    final response = await _dio.get(CommunityEndpoints.postManage(id));
    return ApiResult.fromResponse(
      response,
      (json) => PostResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResult<PostListResponse>> fetchPostsList(PostListRequest request) async {
    final response = await _dio.get(
      CommunityEndpoints.allPosts,
      queryParameters: request.toQueryParameters(),
    );

    return ApiResult.fromResponse(
      response,
      (json) => PostListResponse.fromJson(json as Map<String, dynamic>),
    );
  }
}
