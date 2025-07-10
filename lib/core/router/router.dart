import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/ui/cart/cart_screen.dart';
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
import 'package:provider/provider.dart';

import '../../model/post_dummy.dart';
import '../../ui/auth/login_screen.dart';
import '../../ui/auth/seller_info_screen.dart';
import '../../ui/auth/signup_choice_screen.dart';
import '../../ui/auth/buyer_info_screen.dart';
import '../../ui/main/mypage/mypage_customer/notice.dart';
import '../../ui/main/mypage/mypage_seller/manage_product_seller_screen.dart';
import '../../ui/main/mypage/mypage_seller/mypage_screen_product_manage.dart';
import '../../ui/product/product_detail/product_detail_screen.dart';
import '../../view_model/viewmodel_provider.dart';
import '../../view_model/auth/auth_view_model.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',

  // 1. 로그인 상태 확인 및 리다이렉션 로직을 제거합니다.
  // refreshListenable: ...
  // redirect: ...

  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupChoiceScreen(),
      routes: [
        GoRoute(
          path: 'user',
          builder: (context, state) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => provideNicknameCheckViewModel(),
                ),
                ChangeNotifierProvider(
                  create: (_) => provideBuyerSignupViewModel(),
                ),
              ],
              child: const BuyerInfoScreen(),
            );
          },
        ),
        GoRoute(
          path: 'seller',
          // 2. SellerSignupViewModel 관련 Provider를 제거하고 화면만 반환합니다.
          builder: (context, state) => const SellerInfoScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/community/write',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => providePostCreateViewModel(),
        child: PostCreateScreen(),
      ),
    ),
    GoRoute(
      path: '/post/:id',
      builder: (context, state) {
        final postId = state.pathParameters['id']!;
        return ChangeNotifierProvider(
          create: (_) => providerPostDetailViewModel(postId),
          child: const PostDetailScreen(),
        );
      },
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) {
        return ChangeNotifierProvider(
          create: (_) => provideSearchScreenViewModel(),
          child: SearchScreen(),
        );
      },
    ),
    GoRoute(path: '/cart', builder: (context, state) => CartScreen()),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ChangeNotifierProvider(
          create: (_) => provideProductDetailViewModel(productId),
          child: const ProductDetailScreen(),
        );
      },
    ),
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
          builder: (context, state) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (_) => provideQuestionPostListViewModel()..fetchPosts(reset: true),
                ),
                ChangeNotifierProvider(
                  create: (_) => provideRecommendPostListViewModel()..fetchPosts(reset: true),
                ),
                ChangeNotifierProvider(
                  create: (_) => provideCommunityTabViewModel(),
                ),
              ],
              child: const CommunityScreen(),
            );
          },
        ),
        GoRoute(
          path: '/wishlist',
          builder: (context, state) => const WishlistScreen(),
        ),
        GoRoute(
          path: '/mypage',
          // 3. 동적 로직을 제거하고, 테스트를 위해 판매자 마이페이지를 임시로 고정합니다.
          builder: (context, state) => const MyPageScreenSeller(),
        ),
        GoRoute(
          path: '/notice',
          builder: (context, state) => const NoticeScreen(),
        ),
        GoRoute(
          path: '/seller/products',
          builder: (context, state) => const MyPageProductManageScreen(),
        ),
        GoRoute(
          path: '/seller/orders',
          builder: (context, state) => const ManageProductSellerScreen(),
        ),
      ],
    ),
  ],
);
