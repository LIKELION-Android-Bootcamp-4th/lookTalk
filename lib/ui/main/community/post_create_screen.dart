import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_text.dart';
import 'package:look_talk/ui/common/component/common_dropdown.dart';
import 'package:look_talk/ui/common/component/common_text_field.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:provider/provider.dart';

import '../../../model/entity/post_entity.dart';
import '../../../view_model/community/post_create_view_model.dart';
import '../../common/const/colors.dart';

class PostCreateScreen extends StatelessWidget {
  final List<String> category = ['코디 질문', '코디 추천'];

  PostCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildRegisterButton(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryDropdown(context),
              gap24,
              _buildTitleField(context),
              gap24,
              _buildContentField(context),
              gap24,
              _buildProductButton(context),
              gap24,
              _buildPictureField(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildRegisterButton(BuildContext context) {
    return AppBarText(
      title: '게시글 등록',
      text: '등록',
      onPressed: () async {
        final vm = context.read<PostCreateViewModel>();

        try {
          final postId = await vm.submitPost();
          //print('게시글 프스트 아이디!!! : $postId');
          if (postId != null) {
            context.pop();
            context.push('/post/$postId');
          }else{
            //print('post id가 null 입니다.');
          }
        } catch (e) {
          //print('예외 발생!!!! $e');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      },
    );
  }

  Widget _buildCategoryDropdown(BuildContext context) {
    final vm = context.read<PostCreateViewModel>();
    return CommonDropdown(
      items: vm.categoryMap.keys.toList(),
      onChanged: (label) {
        final value = vm.categoryMap[label];
        if (value != null) vm.setCategory(value);
      },
    );
  }

  Widget _buildTitleField(BuildContext context) {
    final vm = context.read<PostCreateViewModel>();
    return CommonTextField(hintText: '제목', onChanged: vm.setTitle,);
  }

  Widget _buildContentField(BuildContext context) {
    final vm = context.read<PostCreateViewModel>();
    return CommonTextField(hintText: '내용', maxLines: 10, onChanged: vm.setContent,);
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

  Widget _buildPictureField() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.boxGrey,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Icon(Icons.add, size: 50, color: Color(0xFF6F6F6F)),
        ),
      ),
    );
  }
}
