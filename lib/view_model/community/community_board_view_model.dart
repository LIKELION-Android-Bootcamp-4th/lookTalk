import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/response/post_response.dart';
import 'package:look_talk/model/entity/request/post_list_request.dart';
import 'package:look_talk/model/repository/post_repository.dart';
import 'package:look_talk/model/entity/response/post_list_response.dart';

class CommunityBoardViewModel extends ChangeNotifier {
  final PostRepository repository;
  final String category;
  final String? productId;

  List<PostResponse> posts = [];
  bool isLoading = false;
  String? errorMessage;

  CommunityBoardViewModel({required this.repository, required this.category, this.productId,}) {
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await repository.fetchPostList(
        PostListRequest(
          page: 0,
          limit: 30,
          category: category,
          productId: productId,
          sortBy: SortType.createdAt,
          sortOrder: SortOrder.desc,
        ),
      );

      if (result.success && result.data != null) {
        posts = result.data!.items;
        errorMessage = null;
      } else {
        errorMessage = result.message;
      }
    } catch (e) {
      errorMessage = '게시글을 불러오는 데 실패했습니다.';
      print('Error fetching community board posts: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
