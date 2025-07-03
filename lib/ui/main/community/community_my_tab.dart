import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../model/entity/post_entity.dart';
import '../../../model/post_dummy.dart';
import '../../common/component/community/post_list.dart';

class CommunityMyTab extends StatelessWidget {
  const CommunityMyTab({super.key});

  @override
  Widget build(BuildContext context) {
    final myPosts = dummyPosts
        .where((post) => post.category == PostCategory.question)
        .toList();

    return PostList(posts: myPosts);
  }
}
