import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../model/entity/request/post_list_request.dart';
import '../../../model/repository/post_repository.dart';
import '../../../model/entity/response/post_response.dart';
import '../../../ui/common/component/community/post_list.dart';
import '../../../view_model/community/base_post_list_view_model.dart';

class ProductPostListView extends StatefulWidget {
  final String productId;

  const ProductPostListView({super.key, required this.productId});

  @override
  State<ProductPostListView> createState() => _ProductPostListViewState();
}

class _ProductPostListViewState extends State<ProductPostListView> {
  bool _initialized = false;
  int questionPostCount = 2;
  int recommendPostCount = 2;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final vm = context.read<ProductPostListViewModel>();
        vm.fetchPosts();
      });
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductPostListViewModel>();

    if (vm.isLoading && vm.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final questionPosts = vm.posts
        .where((post) => post.category == 'coord_question')
        .toList();

    final recommendPosts = vm.posts
        .where((post) => post.category == 'coord_recommend')
        .toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            title: "코디 질문",
            category: "coord_question",
            posts: questionPosts,
            visibleCount: questionPostCount,
            onMorePressed: () {
              setState(() {
                questionPostCount += 2;
              });
            },
          ),
          const Divider(),
          _buildSection(
            title: "코디 추천",
            category: "coord_recommend",
            posts: recommendPosts,
            visibleCount: recommendPostCount,
            onMorePressed: () {
              setState(() {
                recommendPostCount += 2;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String category,
    required List<PostResponse> posts,
    required int visibleCount,
    required VoidCallback onMorePressed,
  }) {
    final bool isEmpty = posts.isEmpty;
    final visiblePosts = posts.take(visibleCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 제목
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(title, style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16)),
        ),

        // 글 없을 때
        if (isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text("등록된 게시글이 없습니다."),
          ),

        // 글 일부라도 있으면 바로 렌더링
        if (visiblePosts.isNotEmpty)
          PostList(posts: visiblePosts, rootContext: context),

        // 더보기 버튼은 항상 아래쪽
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 4.0),
            child: TextButton(
              onPressed: onMorePressed,
              child: const Text('더보기 +', style: TextStyle(fontSize: 14)),
            ),
          ),
        ),

        const SizedBox(height: 12),
      ],
    );
  }
}

  class ProductPostListViewModel extends BasePostListViewModel {
  ProductPostListViewModel(PostRepository repository, String productId)
      : super(
    repository,
    PostListRequest(
      page: 0,
      limit: 100,
      productId: productId,
      sortBy: SortType.createdAt,
      sortOrder: SortOrder.desc,
    ),
  );
}
