import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_talk/view_model/community/my_post_list_view_model.dart';
import 'package:provider/provider.dart';

import '../../../model/entity/post_entity.dart';
import '../../../model/post_dummy.dart';
import '../../common/component/common_loading.dart';
import '../../common/component/community/post_list.dart';

class CommunityMyTab extends StatelessWidget {
  const CommunityMyTab({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MyPostListViewModel>();

    if (vm.isLoading && vm.posts.isEmpty) {
      return const Center(child: CommonLoading());
    }

    return PostList(posts: vm.posts);
  }
}
