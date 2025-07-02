import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/ui/main/bottom_nav_screen.dart';
import 'package:look_talk/ui/main/category/category/category_screen.dart';
import 'package:look_talk/ui/main/community/community_screen.dart';
import 'package:look_talk/ui/main/home/home_screen.dart';
import 'package:look_talk/ui/main/mypage/mypage_screen.dart';
import 'package:look_talk/ui/main/wishlist/wishlist_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(builder: (context, state, child){
      return BottomNavScreen(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: child,));
    },
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(path: '/category', builder: (context, state) => CategoryScreen()),
        GoRoute(path: '/community', builder: (context, state) => const CommunityScreen()),
        GoRoute(path: '/wishlist', builder: (context, state) => const WishlistScreen()),
        GoRoute(path: '/mypage', builder: (context, state) => const MyPageScreen()),
      ]
    ),
  ]
);
