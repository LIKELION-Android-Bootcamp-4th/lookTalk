import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/request/post_list_request.dart';
import 'package:look_talk/model/entity/response/post_response.dart';
import 'package:look_talk/model/repository/post_repository.dart';
import 'package:look_talk/core/network/api_result.dart';

class CategoryPostListViewModel extends ChangeNotifier {
  final PostRepository repository;
  final String category;
  final String? productId;

  List<PostResponse> posts = [];
  bool isLoading = false;
  bool hasMore = true;

  late PostListRequest request;

  CategoryPostListViewModel(this.repository, this.category, {this.productId}) {
    request = PostListRequest(
      page: 0,
      limit: 10,
      category: category,
      productId: productId,
      sortBy: SortType.createdAt,
      sortOrder: SortOrder.desc,
    );
  }

  Future<void> fetchInitialPosts() async {
    isLoading = true;
    notifyListeners();

    final result = await repository.fetchPostList(request);

    if (result.success && result.data != null) {
      final response = result.data!;
      posts = response.items;
      hasMore = response.items.length == request.limit;
    } else {
      print('초기 글 불러오기 실패: ${result.message}');
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> showMorePosts() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    final nextPage = request.page + 1;
    final nextRequest = request.copyWith(page: nextPage);
    final result = await repository.fetchPostList(nextRequest);

    if (result.success && result.data != null) {
      final response = result.data!;
      posts.addAll(response.items);
      request = nextRequest;
      hasMore = response.items.length == request.limit;
    } else {
      print('더보기 실패: ${result.message}');
    }

    isLoading = false;
    notifyListeners();
  }
}
