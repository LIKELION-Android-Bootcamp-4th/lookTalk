import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../model/entity/request/post_list_request.dart';
import '../../../model/repository/post_repository.dart';
import '../../../model/entity/response/post_response.dart';
import '../../../model/entity/post_entity.dart';
import '../../../ui/common/component/community/post_list.dart';
import '../../../view_model/community/base_post_list_view_model.dart';
import '../../ui/common/component/community/post_item.dart';

class ProductPostListView extends StatefulWidget {
  const ProductPostListView({super.key});

  @override
  State<ProductPostListView> createState() => _ProductPostListViewState();
}

class _ProductPostListViewState extends State<ProductPostListView> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final vm = context.read<ProductPostListViewModel>();
      vm.fetchPosts();
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductPostListViewModel>();

    if (vm.isLoading && vm.posts.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.posts.isEmpty) {
      return const Center(child: Text("등록된 커뮤니티 글이 없습니다."));
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
          _buildSectionHeader(context, "코디 질문", "coord_question"),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: questionPosts.length,
            itemBuilder: (context, index) {
              return PostItem(post: questionPosts[index]);
            },
            separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
              thickness: 0.5,
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
          ),
          const Divider(),
          _buildSectionHeader(context, "코디 추천", "coord_recommend"),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recommendPosts.length,
            itemBuilder: (context, index) {
              return PostItem(post: recommendPosts[index]);
            },
            separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
              thickness: 0.5,
              height: 1,
              indent: 16,
              endIndent: 16,
            ),
          ),
        ],
      ),
    );

  }

  Widget _buildSectionHeader(BuildContext context, String title, String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          GestureDetector(
            onTap: () {
              context.push('/community/board/$category');
            },
            child: const Icon(Icons.chevron_right),
          )
        ],
      ),
    );
  }
}


class ProductPostListViewModel extends BasePostListViewModel {
  ProductPostListViewModel(PostRepository repository, String productId)
      : super(
    repository,
    PostListRequest(
      page: 0,
      limit: 20,
      productId: productId,
      sortBy: SortType.createdAt,
      sortOrder: SortOrder.desc,
    ),
  );

  List<Post> get convertedPosts =>
      posts.map((e) => Post.fromResponse(e)).toList();
}
