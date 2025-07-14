import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/model/entity/response/post_response.dart';

import '../../../../model/entity/post_entity.dart';
import '../../const/colors.dart';
import '../../const/gap.dart';

class PostItem extends StatelessWidget {
  final PostResponse post;

  const PostItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final user = post.user;
    final hasUser = user != null;
    final hasProfileImage = post.user?.profileImageUrl?.isNotEmpty == true;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 왼쪽 Column
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 유저 사진 + 이름
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundImage: hasProfileImage
                          ? NetworkImage(user!.profileImageUrl!)
                          : const AssetImage('assets/images/profile.png') as ImageProvider,
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 200.0,
                      child: Text(
                        hasUser ? user!.nickName : '알 수 없음',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        softWrap: false,
                        overflow: hasProfileImage ? TextOverflow.visible : TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                gap8,

                // 제목
                Text(
                  post.title,
                  style: context.bodyBold,
                  softWrap: false,
                  overflow: hasProfileImage ? TextOverflow.visible : TextOverflow.ellipsis,
                ),

                gap4,

                // 본문
                Text(
                  post.content,
                  maxLines: 1,
                  softWrap: false,
                  overflow:  hasProfileImage ? TextOverflow.visible : TextOverflow.ellipsis,
                ),

                // 좋아요/댓글
                gap8,

                Row(
                  children: [
                    Icon(Icons.favorite, size: 16, color: AppColors.iconGrey),
                    gapW4,
                    Text(
                      '${post.likeCount}',
                      style: context.bodyBold.copyWith(
                        fontSize: 15,
                        color: AppColors.iconGrey,
                      ),
                    ),
                    gapW12,
                    Icon(
                      Icons.chat_bubble,
                      size: 16,
                      color: AppColors.iconGrey,
                    ),
                    gapW4,
                    Text(
                      '${post.commentCount}',
                      style: context.bodyBold?.copyWith(
                        fontSize: 15,
                        color: AppColors.iconGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          gapW12,

          // 오른쪽 Column
          Expanded(
            flex: 2,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (post.images?.main != null && post.images!.main!.isNotEmpty)
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(post.images!.main!),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300],
                    ),
                  )
                else
                  const SizedBox(height: 80),

                gap16,

                Text(
                  _formatDate(post.createdAt),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],

            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays >= 1) {
      return '${date.month}/${date.day}';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}시간 전';
    } else {
      return '${difference.inMinutes}분 전';
    }
  }
}