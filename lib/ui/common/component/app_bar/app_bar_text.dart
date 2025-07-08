import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';

import '../../const/colors.dart';

// 텍스트 버튼만 있는 app bar 입니다.
class AppBarText extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String text;
  final PreferredSizeWidget? bottom;
  final VoidCallback onPressed;

  const AppBarText({
    Key? key,
    this.title,
    required this.text,
    this.bottom,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title ?? ''),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: context.bodyBold.copyWith(color: AppColors.black),
          ),
        ),
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }
}
