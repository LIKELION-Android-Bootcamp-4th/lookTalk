import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/core/theme/app_theme.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_search_cart.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/gap.dart';

class AlterMember extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final thema = AppTheme.light();

    return Scaffold(
      appBar: AppBar(title: Text('회원 정보 수정'),
        titleTextStyle: thema.textTheme.headlineLarge,
      centerTitle: true,
      actions: [
        TextButton(
            onPressed: (){},
            child:
            Text("완료",
            style: context.bodyBold,
            )
            ),
      ],
    ),
      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
          child:
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.grey[400],
            child: Icon(Icons.person, size: 60, color: AppColors.white),
          ),
          ),
          gap4,
          Align(
            child:
          Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade400,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),

            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_alt_rounded),
                Text(' 사진 올리기',
                style: context.bodyBold,),

              ],
            ),
            
          ),
          ),

          Text("이메일",
          style: context.bodyBold,),
          gap4,
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              "abc@naver.com",
              style: context.bodyBold,
            ),
          ),
          gap8,
          Text("닉네임",
          style: context.bodyBold,),


        ],
      ),

    );
  }
}