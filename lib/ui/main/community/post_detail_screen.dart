import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_search_cart.dart';
import 'package:look_talk/ui/common/const/gap.dart';

import '../../../model/entity/post_entity.dart';
import '../../common/const/colors.dart';

class PostDetailScreen extends StatelessWidget{
  // final String postId; // TODO: postId 타입 맞는지 확인
  final Post post;

  const PostDetailScreen({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarSearchCart(),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: context.h1,),
            gap16,
            Row(
              children: [
                Expanded(child: Row(
                  children: [
                    IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border, size: 16)),
                    Text('${post.likeCount}', style: context.h1),
                    gapW16,
                    Icon(Icons.chat_bubble, size: 16, color: AppColors.iconGrey,),
                    Text('${post.commentCount}', style: context.bodyBold?.copyWith(fontSize: 15, color: AppColors.iconGrey)),
                  ],
                )),
                Text('${post.createAt}', style: context.bodyBold.copyWith(color: AppColors.iconGrey),)
              ],
            ),
          ],
        ),
      ),
    );
  }
  
}