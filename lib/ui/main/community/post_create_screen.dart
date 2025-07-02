import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import '../../common/const/colors.dart';

class PostCreateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시글 작성'),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('등록', style: context.bodyBold.copyWith(color: AppColors.black)),
          ),
        ],
      ),
      body: Column(children: [

      ]),
    );
  }
}
