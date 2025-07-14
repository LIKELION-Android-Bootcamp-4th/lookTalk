import 'package:flutter/cupertino.dart';
import 'package:look_talk/model/entity/request/post_list_request.dart';

import '../../model/entity/pagination_entity.dart';
import '../../model/entity/response/post_response.dart';
import '../../model/repository/post_repository.dart';

abstract class BasePostListViewModel with ChangeNotifier {
  final PostRepository repository;
  PostListRequest request;
  List<PostResponse> posts = [];
  Pagination? pagination;

  bool isLoading = false;

  SortType sortType = SortType.createdAt;
  SortOrder sortOrder = SortOrder.desc;

  BasePostListViewModel(this.repository, this.request);

  void changeSort(SortType newType) {
    sortType = newType;
    request = request.copyWith(sortBy: newType);
    fetchPosts(reset: true);
  }

  void changeOrder(SortOrder newOrder) {
    sortOrder = newOrder;
    request = request.copyWith(sortOrder: newOrder);
    fetchPosts(reset: true);
  }

  Future<void> fetchPosts({bool reset = false}) async {
    if (!reset && (pagination != null && !pagination!.hasNext)) return;

    isLoading = true;
    notifyListeners();

    if (reset) {
      pagination = null;
      posts = [];
      request = request.copyWith(page: 0);
    }

    final nextPage = (pagination?.page ?? 0) + 1;

    print('fetchPosts 실행됨 - page: $nextPage');
    print('요청 보냄: ${request.copyWith(page: nextPage)}');

    final result = await repository.fetchPostList(request.copyWith(page: nextPage));

    if (result.success && result.data != null) {
      print('불러온 게시글 개수: ${result.data!.items.length}');
      posts.addAll(result.data!.items);
      pagination = result.data!.pagination;
    } else {
      print('게시글 불러오기 실패: ${result.message}');

    }

    isLoading = false;
    notifyListeners();
  }

}
