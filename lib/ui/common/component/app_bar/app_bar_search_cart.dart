import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 검색, 장바구니 버튼이 있는 app bar 입니다 .
class AppBarSearchCart extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String? title;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;

  const AppBarSearchCart({
    Key? key,
    this.leading,
    this.title,
    this.bottom,
    this.actions
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: Text(title ?? ''),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => context.push('/search')
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () => context.push('/cart')
        ),
        ...?actions,
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
