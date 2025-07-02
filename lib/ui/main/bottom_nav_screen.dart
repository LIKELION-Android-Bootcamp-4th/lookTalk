import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/text_sizes.dart';

class BottomNavScreen extends StatelessWidget {
  final Widget child;

  const BottomNavScreen({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/category')) return 1;
    if (location.startsWith('/community')) return 2;
    if (location.startsWith('/wishlist')) return 3;
    if (location.startsWith('/mypage')) return 4;
    return 0;
  }

  String _getTitle(int index) {
    switch (index) {
      case 1:
        return '카테고리';
      case 2:
        return '커뮤니티';
      case 3:
        return '찜';
      case 4:
        return '마이페이지';
      default:
        return '';
    }
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/category');
        break;
      case 2:
        context.go('/community');
        break;
      case 3:
        context.go('/wishlist');
        break;
      case 4:
        context.go('/mypage');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onTap(context, index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: IconThemeData(size: 32),
        unselectedIconTheme: IconThemeData(size: 26),
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, ), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.list, ), label: '카테고리'),
          BottomNavigationBarItem(icon: Icon(Icons.forum, ), label: '커뮤니티'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite,), label: '찜'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
      ),
    );
  }
}
