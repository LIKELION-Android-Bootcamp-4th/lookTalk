import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:look_talk/core/network/api_result.dart';
import 'package:look_talk/model/client/post_api_client.dart';
import 'package:look_talk/model/entity/request/post_list_request.dart';
import 'package:look_talk/model/entity/response/post_list_response.dart';
import 'package:look_talk/model/entity/response/post_response.dart';

class PostRepository {
  final PostApiClient apiClient;

  PostRepository(this.apiClient);

  Future<ApiResult<PostResponse>> fetchPosts(String id) async {
    return apiClient.fetchPost(id: id);
  }

  Future<ApiResult<PostListResponse>> fetchPostList(PostListRequest request) async {
    return apiClient.fetchPostsList(request);
  }
}
