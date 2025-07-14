import 'package:dio/dio.dart';
import 'package:look_talk/core/network/api_result.dart';
import 'package:look_talk/core/network/end_points/community/community_endpoints.dart';
import 'package:look_talk/model/entity/request/post_list_request.dart';
import 'package:look_talk/model/entity/response/post_response.dart';

import '../entity/request/comment_request.dart';
import '../entity/response/comment_response.dart';
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

  Future<ApiResult<PostListResponse>> fetchPostsList(
      PostListRequest request) async {
    print('[PostApiClient] fetchPostsList 호출됨'); // ✅ 추가
    print('productId: ${request.productId}');
    print('productId runtimeType: ${request.productId.runtimeType}');

    final response = await _dio.get(
      CommunityEndpoints.allPosts,
      queryParameters: request.toQueryParameters(),
      options: Options(validateStatus: (status) => true), // ← 여기 추가
    );
    print('[PostApiClient] 응답 받음 (강제 출력): ${response.data}');


    return ApiResult.fromResponse(
      response,
          (json) => PostListResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResult<void>> toggleLike({required String postId}) async {
    final response = await _dio.post(
      CommunityEndpoints.postLike(postId),
    );
    return ApiResult.fromVoidResponse(response);
  }

  Future<ApiResult<CommentResponse>> addComment({
    required String postId, required CommentRequest request
  }) async {
    final response = await _dio.post(
        CommunityEndpoints.writeComments(postId), data: request.toJson());

    return ApiResult.fromResponse(response, (json) => CommentResponse.fromJson(json as Map<String, dynamic>));
  }

  Future<ApiResult<void>> deletePost(String postId) async {
    final response = await _dio.delete(
      CommunityEndpoints.deletePost(postId)
    );
    return ApiResult.fromVoidResponse(response);
  }


}
