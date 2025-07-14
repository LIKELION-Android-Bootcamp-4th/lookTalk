import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/model/entity/response/post_response.dart';
import '../../../../model/entity/post_entity.dart';
import 'post_item.dart';

class PostList extends StatelessWidget {
  final List<PostResponse> posts;
  final Future<void> Function()? onRefreshAfterDelete;
  final BuildContext rootContext;

  const PostList({
    required this.posts,
    this.onRefreshAfterDelete,
    required this.rootContext,
    super.key,
  });

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
          return GestureDetector(
            onTap: () async {
              final result = await context.push('/post/${posts[index].id}');
              if (result == true && onRefreshAfterDelete != null) {
                await onRefreshAfterDelete!();

                ScaffoldMessenger.of(rootContext).showSnackBar(
                  const SnackBar(
                    content: Text('게시글이 삭제되었습니다.'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: PostItem(post: posts[index]),
          );
        },
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey,
          thickness: 0.5,
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
      ),
    );
  }
}
