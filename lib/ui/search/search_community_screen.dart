import 'package:flutter/material.dart';
import 'package:look_talk/ui/common/component/common_loading.dart';
import 'package:look_talk/view_model/search_view_model.dart';
import 'package:provider/provider.dart';
import '../../../view_model/community/question_post_list_view_model.dart';
import '../common/component/community/post_list.dart';


class SearchCommunityScreen extends StatelessWidget {
  final String category;

  const SearchCommunityScreen({super.key, required this.category});


  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SearchViewModel>();
    final posts = category == '코디질문'
        ? vm.questionCommunities
        : vm.recommendCommunities;

    return Column(
      children: [
        Expanded(
          child: PostList(
            posts: posts,
            onRefresh: () async {
            },
            rootContext: context,
          ),
        ),
      ],
    );
  }
}

