import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 홈, 검색, 장바구니 버튼이 있는 app bar 입니다.
class AppBarHomeSearchCart extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final PreferredSizeWidget? bottom;

  const AppBarHomeSearchCart({this.title, this.bottom, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title ?? ''),
      actions: [
        IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => context.push('/home')
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => context.push('/search')
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () => context.push('/cart')
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
