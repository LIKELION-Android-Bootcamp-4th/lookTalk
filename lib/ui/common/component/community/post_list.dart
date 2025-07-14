import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/response/post_response.dart';
import '../../../../model/entity/post_entity.dart';
import 'post_item.dart';

class PostList extends StatelessWidget {
  final List<PostResponse> posts;

  const PostList({required this.posts, super.key});

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return Center(child: Text('게시글이 없습니다.'));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 12),
      child: ListView.separated(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostItem(post: posts[index]);
        },
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey,
          thickness: 0.5,
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
      )
    );
  }
}
