import 'dart:io';

import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/component/common_dropdown.dart';
import 'package:look_talk/ui/common/component/common_text_field.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import '../../common/const/colors.dart';

class PostCreateScreen extends StatelessWidget {
  final List<String> category = ['코디 질문', '코디 추천'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 작성'),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              '등록',
              style: context.bodyBold.copyWith(color: AppColors.black),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonDropdown(items: category, onChanged: (value) {}),
              gap24,
              CommonTextField(hintText: '제목'),
              gap24,
              CommonTextField(hintText: '내용', maxLines: 10,),
              gap24,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('상품 정보 추가', style: context.bodyBold,),
                  Icon(Icons.chevron_right_rounded, size: 24, color: AppColors.black,)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
