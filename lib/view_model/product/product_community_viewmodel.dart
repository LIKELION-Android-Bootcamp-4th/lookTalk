import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/request/post_list_request.dart';
import 'package:look_talk/model/entity/response/post_response.dart';
import 'package:look_talk/model/repository/post_repository.dart';
import 'package:look_talk/model/entity/response/post_list_response.dart';

class ProductCommunityViewModel extends ChangeNotifier {
  final PostRepository repository;
  final String productId;

  List<PostResponse> questionPosts = [];
  List<PostResponse> recommendPosts = [];

  bool isLoading = false;
  String? errorMessage;

  ProductCommunityViewModel({required this.repository, required this.productId}) {
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    isLoading = true;
    notifyListeners();

    try {
      final questionResult = await repository.fetchPostList(
        PostListRequest(
          page: 0,
          limit: 10,
          category: 'coord_question',
          productId: productId,
        ),
      );
      final recommendResult = await repository.fetchPostList(
        PostListRequest(
          page: 0,
          limit: 10,
          category: 'coord_recommend',
          productId: productId,
        ),
      );

      if (questionResult.success) {
        questionPosts = questionResult.data?.items ?? [];
      }

      if (recommendResult.success) {
        recommendPosts = recommendResult.data?.items ?? [];
      }

      errorMessage = null;
    } catch (e) {
      errorMessage = '글을 불러오지 못했습니다.';
      print('상품 커뮤니티 글 불러오기 오류: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
