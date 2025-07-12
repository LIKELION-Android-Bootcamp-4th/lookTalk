import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/component/primary_button.dart';
import 'package:provider/provider.dart';
import '../../../model/entity/post_entity.dart';
import '../../../view_model/community/post_detail_view_model.dart';
import '../../common/component/app_bar/app_bar_search_cart.dart';
import '../../common/component/community/comment_item.dart';
import '../../common/const/colors.dart';
import '../../common/const/gap.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PostDetailViewModel>();
    final post = viewModel.post;

    if (viewModel.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (viewModel.errorMessage != null) {
      return Scaffold(body: Center(child: Text(viewModel.errorMessage!)));
    }

    if (post == null) {
      return const Scaffold(body: Center(child: Text('게시글이 존재하지 않습니다.')));
    }
    return Scaffold(
      appBar: const AppBarSearchCart(),
      body: ListView(
        children: [
          gap16,
          _buildUserInfo(context, post),
          gap16,
          _buildContents(context, post),
          gap8,
          _buildPhoto(post),
          gap8,
          _buildProductInfo(post, context),
          gap8,
          _buildPostStats(post, viewModel, context),
          gap8,
          _buildDivider(),
          ..._buildCommentListItems(post),
          gap128,
        ],
      ),
      bottomSheet: _buildCommentInput(viewModel),
    );

    // return Scaffold(
    //   appBar: const AppBarSearchCart(),
    //   body: ListView(
    //     //crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 24.0),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             _buildUserInfo(context, post),
    //             gap16,
    //             _buildContents(context, post),
    //             gap8,
    //             _buildPhoto(post),
    //             gap8,
    //             _buildPostStats(post, viewModel, context),
    //             gap4,
    //             _buildDivider(),
    //             ..._buildCommentListItems(post),
    //           ],
    //         ),
    //       ),
    //       // _buildDivider(),
    //       // Expanded(child: _buildCommentList(post)),
    //     ],
    //   ),
    //   bottomSheet: _buildCommentInput(viewModel),
    // );
  }

  Widget _buildUserInfo(BuildContext context, Post post) {
    final hasProfileImage = post.user.profileImageUrl?.isNotEmpty == true;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 21,
            backgroundImage: hasProfileImage
                ? NetworkImage(post.user.profileImageUrl!)
                : const AssetImage('assets/images/profile.png')
                      as ImageProvider,
          ),
          gapW8,
          Text(post.user.nickName, style: context.h1.copyWith(fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildContents(BuildContext context, Post post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.title, style: context.h1),
          gap8,
          Text(post.content, style: context.bodyBold),
        ],
      ),
    );
  }

  Widget _buildPhoto(Post post) {
    final imageUrl = post.user.profileImageUrl;

    if (imageUrl == null || imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[300],
        ),
      ),
    );
  }

  Widget _buildProductInfo(Post post, BuildContext context) {
    final product = post.product;

    if (product == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (product.thumbnailImageUrl != null &&
              product.thumbnailImageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.thumbnailImageUrl!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image_not_supported, color: Colors.grey),
            ),

          const SizedBox(width: 16),

          // 상품 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TODO : 상점명, 할인율 서버에서 오는 값으로 바꾸기
                gap4,
                Text(
                  post.product?.storeName ?? '상점 정보 없음',
                  style: context.body.copyWith(
                    fontSize: 12,
                    color: AppColors.textGrey,
                  ),
                ),
                Text(product.name, style: context.body),
                gap4,
                Row(
                  children: [
                    Text('25%', style: context.h1.copyWith(color: AppColors.red, fontSize: 14)),
                    gapW8,
                    Text(
                      '${product.price}원',
                      style: context.h1.copyWith(fontSize: 14),
                    ),
                  ],
                ),
                
              ],
            ),
          ),

          // 상품 보기 버튼
          ElevatedButton(
            onPressed: () {
              // TODO: 상품 상세 페이지로 이동 (id 넘겨주기)
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: const Size(0, 32),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              textStyle: const TextStyle(fontSize: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
                side: const BorderSide(color: AppColors.black, width: 1.3),
              ),
              elevation: 0,
            ),
            child: Text(
              "상품 보기",
              style: context.bodyBold.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostStats(
    Post post,
    PostDetailViewModel viewModel,
    BuildContext context,
  ) {
    String _formatDate(DateTime date) {
      String _twoDigits(int n) => n.toString().padLeft(2, '0');
      return '${_twoDigits(date.month)}/${_twoDigits(date.day)}  ${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
    }

    final isLiked = viewModel.isLiked;
    print('isLiked값!!! : $isLiked');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.black,
                    size: 24,
                  ),
                  onPressed: () {
                    viewModel.toggleLike();
                  },
                ),
                Text('${post.likeCount}', style: context.h1),
                gapW24,
                const Icon(
                  Icons.chat_bubble,
                  size: 16,
                  color: AppColors.iconGrey,
                ),
                gapW12,
                Text(
                  '${post.commentCount}',
                  style: context.bodyBold.copyWith(
                    fontSize: 15,
                    color: AppColors.iconGrey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatDate(post.createAt),
            style: context.bodyBold.copyWith(color: AppColors.iconGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: AppColors.iconGrey,
      thickness: 1,
      //height: 32,
    );
  }

  // Widget _buildCommentList(Post post) {
  //   final comments = post.comments;
  //
  //   if (comments.isEmpty) {
  //     return const Padding(
  //       padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
  //       child: Text('아직 댓글이 없습니다. 첫 댓글을 남겨보세요!'),
  //     );
  //   }
  //
  //   return ListView.builder(
  //     padding: const EdgeInsets.symmetric(horizontal: 24.0),
  //     itemCount: comments.length,
  //     itemBuilder: (context, index) {
  //       return CommentItem(comment: comments[index]);
  //     },
  //   );
  // }

  List<Widget> _buildCommentListItems(Post post) {
    final comments = post.comments;

    if (comments.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('아직 댓글이 없습니다. 첫 댓글을 남겨보세요!'),
        ),
      ];
    }

    return comments
        .map(
          (comment) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: CommentItem(comment: comment),
          ),
        )
        .toList();
  }

  Widget _buildCommentInput(PostDetailViewModel viewModel) {
    return SafeArea(
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 25,
            right: 15,
            left: 15,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.blueButton,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                gapW8,
                Expanded(
                  child: TextField(
                    controller: viewModel.commentController,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력해주세요.',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: AppColors.textGrey),
                    ),
                  ),
                ),
                Consumer<PostDetailViewModel>(
                  builder: (context, viewModel, _) {
                    return IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        final postId = viewModel.post?.id;
                        if (postId != null) {
                          await viewModel.submitComment(postId);
                        } else {
                          print('post id가 null!!! ');
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
