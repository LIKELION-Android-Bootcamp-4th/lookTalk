import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';

import '../../../../model/entity/post_entity.dart';
import '../../const/colors.dart';
import '../../const/gap.dart';

class PostItem extends StatelessWidget {
  final Post post;

  const PostItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print('/post/${post.id}');
        context.push('/post/${post.id}');
      },
      child: Padding(
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
                        backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150', // 유저 프로필 사진
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('홍길동', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  gap8,

                  // 제목
                  Text(post.title, style: context.bodyBold),

                  // 본문 1줄
                  gap4,

                  Text(
                    post.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // 좋아요/댓글
                  gap8,

                  Row(
                    children: [
                      Icon(Icons.favorite, size: 16, color: AppColors.iconGrey,),
                      gapW4,
                      Text('${post.likeCount}', style: context.bodyBold?.copyWith(fontSize: 15, color: AppColors.iconGrey),),
                      gapW12,
                      Icon(Icons.chat_bubble, size: 16, color: AppColors.iconGrey,),
                      gapW4,
                      Text('${post.commentCount}', style: context.bodyBold?.copyWith(fontSize: 15, color: AppColors.iconGrey)),
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // TODO: 서버에서 불러온 이미지로 바꾸기
                  if (post.productId != null)
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage('https://via.placeholder.com/80'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[300],
                      ),
                    )
                  else
                    SizedBox(height: 80), // 이미지 없을 경우 빈 공간 유지

                  gap8,

                  // 날짜 표시
                  Text(
                    _formatDate(post.createAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
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

