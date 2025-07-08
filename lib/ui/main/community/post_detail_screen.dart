// import 'package:flutter/material.dart';
// import 'package:look_talk/core/extension/text_style_extension.dart';
// import 'package:look_talk/ui/common/component/app_bar/app_bar_search_cart.dart';
// import 'package:look_talk/ui/common/const/gap.dart';
// import 'package:look_talk/view_model/community/post_detail_view_model.dart';
// import 'package:provider/provider.dart';
//
// import '../../../model/entity/post_entity.dart';
// import '../../common/const/colors.dart';
//
// class PostDetailScreen extends StatefulWidget{
//   final String postId;
//
//   const PostDetailScreen({required this.postId, super.key});
//
//   @override
//   State<PostDetailScreen> createState() => _PostDetailScreenState();
// }
//
// class _PostDetailScreenState extends State<PostDetailScreen> {
//   @override
//   void initState() {
//     super.initState();
//     final viewModel = context.read<PostDetailViewModel>();
//     viewModel.fetchPost(widget.postId);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = context.watch<PostDetailViewModel>();
//
//     if (viewModel.isLoading) return CircularProgressIndicator();
//     if (viewModel.errorMessage != null) return Text(viewModel.errorMessage!);
//     if (viewModel.post == null) return Text('데이터 없음');
//
//     return Scaffold(
//       appBar: AppBarSearchCart(),
//       body: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(padding: EdgeInsets.symmetric(vertical: 12),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 12,
//                   backgroundImage: NetworkImage(
//                     'https://via.placeholder.com/150',
//                   ),
//                 ),
//                 gapW8,
//                 Text('홍길동', style: TextStyle(fontWeight: FontWeight.bold,
//                 color: AppColors.textGrey)),
//               ],
//             ),
//             ),
//             Text(post.content, style: context.bodyBold,),
//             gap16,
//             Row(
//               children: [
//                 Expanded(child: Row(
//                   children: [
//                     IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border, size: 16)),
//                     Text('${post.likeCount}', style: context.h1),
//                     gapW16,
//                     Icon(Icons.chat_bubble, size: 16, color: AppColors.iconGrey,),
//                     Text('${post.commentCount}', style: context.bodyBold?.copyWith(fontSize: 15, color: AppColors.iconGrey)),
//                   ],
//                 )),
//                 Text(
//                   _formatDate(post.createAt),
//                   style: context.bodyBold.copyWith(color: AppColors.iconGrey),)
//               ],
//             ),
//           ],
//         ),
//       ),
//       bottomSheet: //bottomSheetNavigater를 사용해봤는데, 하단에 아에 고정이 되어 키보드에 가려져 수정.
//       SafeArea(child: _commentInput()),
//
//     );
//   }
//
//   String _formatDate(DateTime date){
//     return '${date.year}.${_twoDigits(date.month)}.${_twoDigits(date.day)}';
//   }
//
//   String _twoDigits(int n){
//     return n.toString().padLeft(2,'0');
//   }
// }
//
// Widget _commentInput() {
//   return Padding(padding:EdgeInsets.only(bottom: 20),
//   child:
//     Container(
//     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
//     decoration: BoxDecoration(
//       color: AppColors.blueButton,
//       borderRadius: BorderRadius.circular(20),
//     ),
//     child: Row(
//       children: [
//         Expanded(
//           child: TextField(
//             decoration: const InputDecoration(
//               hintText: '댓글을 입력해주세요.',
//               border: InputBorder.none,
//             ),
//           ),
//         ),
//         IconButton(
//           onPressed: () {},
//           icon: const Icon(Icons.send),
//         ),
//       ],
//     ),
//     ),
//   );
// }


import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:provider/provider.dart';
import '../../../model/entity/post_entity.dart';
import '../../../view_model/community/post_detail_view_model.dart';
import '../../common/component/app_bar/app_bar_search_cart.dart';
import '../../common/const/colors.dart';
import '../../common/const/gap.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PostDetailViewModel>();
    final post = viewModel.post;

    if (viewModel.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (viewModel.errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(viewModel.errorMessage!)),
      );
    }

    if (post == null) {
      return const Scaffold(
        body: Center(child: Text('게시글이 존재하지 않습니다.')),
      );
    }

    return Scaffold(
      appBar: const AppBarSearchCart(),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(),
            gap16,
            Text(post.title, style: context.h1,),
            Text(post.content, style: context.bodyBold),
            gap16,
            _buildPostStats(post, context),
          ],
        ),
      ),
      bottomSheet: const _CommentInput(),
    );
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 12,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          gapW8,
          Text(
            '홍길동',
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildPostStats(Post post, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border, size: 16)),
              Text('${post.likeCount}', style: context.h1),
              gapW16,
              const Icon(Icons.chat_bubble, size: 16, color: AppColors.iconGrey),
              Text(
                '${post.commentCount}',
                style: context.bodyBold.copyWith(fontSize: 15, color: AppColors.iconGrey),
              ),
            ],
          ),
        ),
        Text(
          _formatDate(post.createAt),
          style: context.bodyBold.copyWith(color: AppColors.iconGrey),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${_twoDigits(date.month)}.${_twoDigits(date.day)}';
  }

  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }
}

class _CommentInput extends StatelessWidget {
  const _CommentInput({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal:  20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.blueButton,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                gapW8,
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '댓글을 입력해주세요.',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: AppColors.textGrey)
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
        ),
      ),
    );
  }
}

