import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryDropdown(),
              gap24,
              _buildTitleField(),
              gap24,
              _buildContentField(),
              gap24,
              _buildProductButton(context),
              gap24,
              _buildPictureField()
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildCategoryDropdown() {
    return CommonDropdown(items: category, onChanged: (value) {});
  }

  Widget _buildTitleField() {
    return CommonTextField(hintText: '제목');
  }

  Widget _buildContentField() {
    return CommonTextField(hintText: '내용', maxLines: 10);
  }

  Widget _buildProductButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/community/write/product-register');
      },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: Colors.black, width: 1.2),
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('상품 정보 추가', style: context.bodyBold),
            Icon(Icons.chevron_right_rounded, size: 24, color: AppColors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildPictureField(){
    return GestureDetector(
      onTap: (){},
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            color: AppColors.boxGrey,
            borderRadius: BorderRadius.circular(22)
        ),
        child: Center(
          child: Icon(Icons.add, size: 50, color: Color(0xFF6F6F6F),),
        ),
      ),
    );
  }

}
