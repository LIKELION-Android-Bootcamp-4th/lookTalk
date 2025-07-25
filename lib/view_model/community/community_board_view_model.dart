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

  CommunityBoardViewModel({
    required this.repository,
    required this.category,
    this.productId,
  }) {
    print('[CommunityBoardViewModel] 생성됨');
    print('  category: $category');
    print('  productId: $productId');
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    isLoading = true;
    notifyListeners();

    print('[fetchPosts] 게시글 요청 시작');
    print('  category: $category');
    print('  productId: $productId');

    print('[검사] category isEmpty: ${category.isEmpty}');
    print('[검사] productId isEmpty: ${productId?.isEmpty}');

    try {
      final request = PostListRequest(
        page: 0,
        limit: 30,
        category: category,
        productId: productId,
        sortBy: SortType.createdAt,
        sortOrder: SortOrder.desc,
      );


      final result = await repository.fetchPostList(request);

      if (result.success && result.data != null) {
        posts = result.data!.items;
        errorMessage = null;
        print('  ✅ 게시글 ${posts.length}개 불러옴');
      } else {
        errorMessage = result.message;
        print('  ⚠️ 게시글 요청 실패: ${result.message}');
      }
    } catch (e) {
      errorMessage = '게시글을 불러오는 데 실패했습니다.';
      print('❌ 예외 발생: $e');
    } finally {
      isLoading = false;
      notifyListeners();
      print('[fetchPosts] 게시글 요청 종료');
    }
  }
}
