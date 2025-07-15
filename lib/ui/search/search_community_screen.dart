import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/search_view_model.dart';
import '../common/component/app_bar/app_bar_search_cart.dart';

class SearchCommunityScreen extends StatelessWidget {
  final String category;

  const SearchCommunityScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModel>();
    final posts = category == '코디질문'
        ? vm.questionCommunities
        : vm.recommendCommunities;

    return Scaffold(
      appBar: AppBarSearchCart(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            posts.length,
                (index) {
              final post = posts[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text("총 개수${posts.length}"), // 또는 Text(post.title) 등
              );
            },
          ),
        ),
      ),
    );
  }
}
