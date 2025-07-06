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
            Padding(padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150',
                  ),
                ),
                gapW8,
                Text('홍길동', style: TextStyle(fontWeight: FontWeight.bold,
                color: AppColors.textGrey)),
              ],
            ),
            ),
            Text(post.content, style: context.bodyBold,),
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
                Text(
                  _formatDate(post.createAt),
                  style: context.bodyBold.copyWith(color: AppColors.iconGrey),)
              ],
            ),
          ],
        ),
      ),
      bottomSheet: //bottomSheetNavigater를 사용해봤는데, 하단에 아에 고정이 되어 키보드에 가려져 수정.
      SafeArea(child: _commentInput()),

    );
  }

  String _formatDate(DateTime date){
    return '${date.year}.${_twoDigits(date.month)}.${_twoDigits(date.day)}';
  }

  String _twoDigits(int n){
    return n.toString().padLeft(2,'0');
  }
  
}

Widget _commentInput() {
  return Padding(padding:EdgeInsets.only(bottom: 20),
  child:
    Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(
      color: AppColors.blueButton,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              hintText: '댓글을 입력해주세요.',
              border: InputBorder.none,
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.send),
        ),
      ],
    ),
    ),
  );
}
