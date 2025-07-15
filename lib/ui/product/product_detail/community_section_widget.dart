import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/ui/common/component/community/post_item.dart';
import 'package:look_talk/view_model/community/category_post_list_viewmodel.dart';
import 'package:look_talk/model/repository/post_repository.dart';
import 'package:look_talk/model/client/post_api_client.dart';
import 'package:look_talk/core/network/dio_client.dart';

class CommunitySectionWidget extends StatelessWidget {
  final String category;
  final String title;
  final String? productId;

  const CommunitySectionWidget({
    super.key,
    required this.category,
    required this.title,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryPostListViewModel(
        PostRepository(PostApiClient(DioClient.instance)),
        category,
        productId: productId,
      )..fetchInitialPosts(),
      child: Consumer<CategoryPostListViewModel>(
        builder: (context, vm, _) {
          final previewPosts = vm.posts.take(2).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목 + 더보기 버튼
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    if ((vm.hasMore || vm.posts.length > 2) && !vm.isLoading)
                      TextButton(
                        onPressed: vm.showMorePosts,
                        child: const Text('더보기 +'),
                      ),
                  ],
                ),
              ),

              // 게시글 미리보기 (2개만)
              ...previewPosts.map((post) => PostItem(post: post)).toList(),

              // 로딩 인디케이터
              if (vm.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: CircularProgressIndicator(),
                  ),
                ),

              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
