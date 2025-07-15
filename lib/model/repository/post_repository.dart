import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:look_talk/core/network/api_result.dart';
import 'package:look_talk/model/client/post_api_client.dart';
import 'package:look_talk/model/entity/request/post_list_request.dart';
import 'package:look_talk/model/entity/response/post_list_response.dart';
import 'package:look_talk/model/entity/response/post_response.dart';

import '../entity/request/comment_request.dart';
import '../entity/response/comment_response.dart';

class PostRepository {
  final PostApiClient _apiClient;

  PostRepository(this._apiClient);

  Future<ApiResult<PostResponse>> fetchPosts(String id) async {
    return _apiClient.fetchPost(id: id);
  }

  Future<ApiResult<PostListResponse>> fetchPostList(PostListRequest request) async {
    return _apiClient.fetchPostsList(request);
  }

  Future<void> toggleLike(String postId) async {
    await _apiClient.toggleLike(postId: postId);
  }

  Future<ApiResult<CommentResponse>> addComment({
    required String postId,
    required CommentRequest request,
}) {
    return _apiClient.addComment(postId: postId, request: request);
  }

  Future<ApiResult<void>> deletePost(String postId) async{
    return await _apiClient.deletePost(postId);
  }
}
