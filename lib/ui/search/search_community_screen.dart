import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/search_view_model.dart';
import '../common/component/app_bar/app_bar_search_cart.dart';
import '../common/component/community/post_item.dart';

class SearchCommunityScreen extends StatelessWidget {
  final String category;

  const SearchCommunityScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModel>();
    final posts = category == 'coord_question'
        ? vm.questionCommunities
        : vm.recommendCommunities;
print('{총 개수 ${posts.length}');
    return Scaffold(
      appBar: category == 'coord_question'
          ?AppBarSearchCart(title: "코디 질문",)
          :AppBarSearchCart(title: "코디 추천",),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            posts.length,
                (index) {
              final post = posts[index];
               return (post != null)
                  ? PostItem(post: post)
                  : const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
