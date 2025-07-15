import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/model/entity/response/post_response.dart';
import 'package:look_talk/ui/common/component/community/post_item.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';

class ProductCommunityTab extends StatelessWidget {
  final List<PostResponse> questionPosts;
  final List<PostResponse> recommendPosts;
  final String productId; // ✅ productId 추가

  const ProductCommunityTab({
    super.key,
    required this.questionPosts,
    required this.recommendPosts,
    required this.productId, // ✅ 생성자에도 추가
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSection(
          context,
          title: '코디 질문',
          posts: questionPosts,
          category: 'coord_question',
        ),
        const SizedBox(height: 24),
        _buildSection(
          context,
          title: '코디 추천',
          posts: recommendPosts,
          category: 'coord_recommend',
        ),
      ],
    );
  }

  Widget _buildSection(
      BuildContext context, {
        required String title,
        required List<PostResponse> posts,
        required String category,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목 + 버튼
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: context.h2),
              TextButton(
                onPressed: () {
                  context.push('/community/board/$category?productId=$productId'); // ✅ productId 포함
                },
                child: const Text('>'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // 게시글 미리보기 (최대 3개)
        ...posts.take(3).map((post) => PostItem(post: post)).toList(),
      ],
    );
  }
}
