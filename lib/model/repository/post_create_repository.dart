import 'package:look_talk/model/entity/response/post_create_response.dart';

import '../../core/network/api_result.dart';
import '../client/psot_create_api_client.dart';
import '../entity/request/post_create_request.dart';

class PostCreateRepository {
  final PostCreateApiClient apiClient;

  PostCreateRepository(this.apiClient);

  Future<ApiResult<PostCreateResponse>> createPost({
    required PostCreateRequest request,
  }) async {
    return apiClient.createPost(request: request);
  }
}
