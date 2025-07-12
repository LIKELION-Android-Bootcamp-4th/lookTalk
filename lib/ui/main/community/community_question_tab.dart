import 'package:flutter/material.dart';
import 'package:look_talk/ui/common/component/common_loading.dart';
import 'package:provider/provider.dart';
import '../../../model/entity/post_entity.dart';
import '../../../model/post_dummy.dart';
import '../../../view_model/community/question_post_list_view_model.dart';
import '../../common/component/community/post_list.dart';

class CommunityQuestionTab extends StatelessWidget {
  const CommunityQuestionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuestionPostListViewModel>();

    if (vm.isLoading && vm.posts.isEmpty) {
      return const Center(child: CommonLoading());
    }

    if (!vm.isLoading && vm.posts.isEmpty) {
      return const Center(child: Text('게시글이 없습니다.'));
    }

    return PostList(posts: vm.posts);
  }
}
