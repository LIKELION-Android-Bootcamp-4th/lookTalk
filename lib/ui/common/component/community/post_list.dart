import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/model/entity/response/post_response.dart';
import '../../../../model/entity/post_entity.dart';
import 'post_item.dart';

class PostList extends StatelessWidget {
  final List<PostResponse> posts;
  final Future<void> Function()? onRefresh;
  final BuildContext rootContext;

  const PostList({
    required this.posts,
    this.onRefresh,
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
              if (result == 'deleted' && onRefresh != null) {
                await onRefresh!();

                ScaffoldMessenger.of(rootContext).showSnackBar(
                  const SnackBar(
                    content: Text('게시글이 삭제되었습니다.'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (result == 'updated' && onRefresh != null) {
                await onRefresh!(); // 댓글 수/좋아요 수 갱신
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