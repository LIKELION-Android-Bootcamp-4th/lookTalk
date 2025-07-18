import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/model/entity/comment.dart';

import '../../const/colors.dart';
import '../../const/gap.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;

  const CommentItem({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfoRow(context),
          gap8,
          _buildCommentContent(context),
          gap8,
          _buildCreatedAt(context),
        ],
      ),
    );
  }

  Widget _buildUserInfoRow(BuildContext context) {
    final hasProfileImage = comment.user.profileImageUrl?.isNotEmpty == true;

    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: hasProfileImage
              ? NetworkImage(comment.user.profileImageUrl!)
              : const AssetImage('assets/images/profile.png') as ImageProvider,
        ),
        gapW12,
        Text(
          comment.user.nickName,
          style: context.bodyBold.copyWith(color: AppColors.textGrey)
        ),
      ],
    );
  }

  Widget _buildCommentContent(BuildContext context) {
    return Text(
      comment.content,
      style: context.bodyBold,
    );
  }

  Widget _buildCreatedAt(BuildContext context) {
    return Text(
      _formatDate(comment.createdAt),
      style: context.body.copyWith(
        fontSize: 12,
        color: AppColors.textGrey,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$month/$day $hour:$minute';
  }
}
