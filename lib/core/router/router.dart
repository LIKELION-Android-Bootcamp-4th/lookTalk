import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/ui/cart/cart_screen.dart';
import 'package:look_talk/ui/main/community/product_register_screen.dart';
import 'package:look_talk/ui/main/bottom_nav_screen.dart';
import 'package:look_talk/ui/main/category/category/category_screen.dart';
import 'package:look_talk/ui/main/community/community_screen.dart';
import 'package:look_talk/ui/main/community/post_create_screen.dart';
import 'package:look_talk/ui/main/community/post_detail_screen.dart';
import 'package:look_talk/ui/main/home/home_screen.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/mypage_screen.dart';
import 'package:look_talk/ui/main/mypage/mypage_seller/mypage_screen_seller.dart';
import 'package:look_talk/ui/main/wishlist/wishlist_screen.dart';
import 'package:look_talk/ui/search/search_screen.dart';
import 'package:look_talk/view_model/auth/login_view_model.dart';
import 'package:provider/provider.dart';

import '../../model/post_dummy.dart';
import '../../ui/auth/login_screen.dart';
import '../../ui/auth/seller_info_screen.dart';
import '../../ui/auth/signup_choice_screen.dart';
import '../../ui/auth/user_info_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
          child: const LoginScreen(),
        );
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) {
        final email = state.uri.queryParameters['email']!;
        final provider = state.uri.queryParameters['provider']!;
        return SignupChoiceScreen(email: email, provider: provider);
      },
      routes: [
        GoRoute(
          path: 'user',
          builder: (context, state) {
            final email = state.uri.queryParameters['email']!;
            final provider = state.uri.queryParameters['provider']!;
            final role = state.uri.queryParameters['platformRole']!;
            return UserInfoScreen(
              email: email,
              provider: provider,
              role: role,
            );
          },
        ),
        GoRoute(
          path: 'seller',
          builder: (context, state) {
            final email = state.uri.queryParameters['email']!;
            final provider = state.uri.queryParameters['provider']!;
            final role = state.uri.queryParameters['platformRole']!;
            return SellerInfoScreen(
              email: email,
              provider: provider,
              role: role,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/community/write',
      builder: (context, state) => PostCreateScreen(),
      routes: [
        GoRoute(
          path: 'product-register',
          builder: (context, state) => ProductRegisterScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/post/:id',
      builder: (context, state) {
        final postId = state.pathParameters['id']!;
        final post = dummyPosts.firstWhere(
          (p) => p.id == postId,
        ); // TODO: 서버 요청시 제외하기
        return PostDetailScreen(post: post);
      },
    ),
    GoRoute(path: '/search', builder: (context, state) => SearchScreen()),
    GoRoute(path: '/cart', builder: (context, state) => CartScreen()),
    ShellRoute(
      builder: (context, state, child) {
        return BottomNavScreen(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: child,
          ),
        );
      },
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/category',
          builder: (context, state) => CategoryScreen(),
        ),
        GoRoute(
          path: '/community',
          builder: (context, state) => const CommunityScreen(),
        ),
        GoRoute(
          path: '/wishlist',
          builder: (context, state) => const WishlistScreen(),
        ),
        GoRoute(
          path: '/mypage',
          builder: (context, state) => const MyPageScreenCustomer(),
        ),
      ],
    ),
  ],
);
