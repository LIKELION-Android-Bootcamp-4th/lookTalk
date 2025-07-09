import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:look_talk/core/network/api_result.dart';
import 'package:look_talk/model/client/post_api_client.dart';
import 'package:look_talk/model/entity/response/post_response.dart';

import '../entity/post_entity.dart';

class PostRepository {
  final PostApiClient apiClient;

  PostRepository(this.apiClient);

  Future<ApiResult<PostResponse>> fetchPosts(String id) async {
    return apiClient.fetchPost(id: id);
  }
}
