import 'package:flutter/material.dart';
import '../../../model/entity/post_entity.dart';
import '../../../model/post_dummy.dart';
import '../../common/component/community/post_list.dart';

class CommunityQuestionTab extends StatelessWidget {
  const CommunityQuestionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final questionPosts = dummyPosts
        .where((post) => post.category == PostCategory.question)
        .toList();

    return PostList(posts: questionPosts);
  }
}
