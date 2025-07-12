import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/post_entity.dart';
import 'package:look_talk/model/post_dummy.dart';
import 'package:look_talk/view_model/community/recommend_post_list_view_model.dart';
import 'package:provider/provider.dart';

import '../../common/component/common_loading.dart';
import '../../common/component/community/post_list.dart';

class CommunityRecommendTab extends StatelessWidget {
  const CommunityRecommendTab({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RecommendPostListViewModel>();

    if (vm.isLoading && vm.posts.isEmpty) {
      return const Center(child: CommonLoading());
    }

    return PostList(posts: vm.posts);
  }
}