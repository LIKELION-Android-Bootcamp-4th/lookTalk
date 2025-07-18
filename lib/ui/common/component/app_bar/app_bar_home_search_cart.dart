import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/auth_guard.dart';

// 홈, 검색, 장바구니 버튼이 있는 app bar 입니다.
class AppBarHomeSearchCart extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final PreferredSizeWidget? bottom;
  final Widget? leading;

  const AppBarHomeSearchCart({this.title, this.bottom, this.leading, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title ?? ''),
      leading: leading,
      scrolledUnderElevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.home_outlined),
          onPressed: () => context.push('/home')
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => context.push('/search')
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () {
            navigateWithAuthCheck(
              context: context,
              destinationIfLoggedIn: '/cart', // 로그인 시 목적지
              fallbackIfNotLoggedIn: '/login', // 비로그인 시 목적지
            );
          },
        ),
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize{
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;
    return Size.fromHeight(bottomHeight + kToolbarHeight);
  }
}
