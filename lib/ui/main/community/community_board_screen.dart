import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/view_model/community/community_board_view_model.dart';
import 'package:look_talk/ui/common/component/community/post_list.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';

class CommunityBoardScreen extends StatelessWidget {
  final String category;
  final String? productId;

  const CommunityBoardScreen({
    super.key,
    required this.category,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CommunityBoardViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(category), style: context.h1),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Builder(
        builder: (_) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.posts.isEmpty) {
            return const Center(child: Text("해당 게시판에 글이 없습니다."));
          }
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: PostList(
              posts: vm.posts,
              rootContext: context,
            ),
          );
        },
      ),
    );
  }

  String _getTitle(String category) {
    switch (category) {
      case 'coord_question':
        return '코디 질문 게시판';
      case 'coord_recommend':
        return '코디 추천 게시판';
      default:
        return '게시판';
    }
  }
}
