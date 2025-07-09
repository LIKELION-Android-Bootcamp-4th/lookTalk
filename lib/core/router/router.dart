import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/model/client/auth_api_client.dart';
import 'package:look_talk/ui/cart/cart_screen.dart';
import 'package:look_talk/ui/common/component/common_loading.dart';
import 'package:look_talk/ui/main/bottom_nav_screen.dart';
import 'package:look_talk/ui/main/category/category/category_screen.dart';
import 'package:look_talk/ui/main/community/communication_product_registration/product_registration-screen.dart';
import 'package:look_talk/ui/main/community/community_screen.dart';
import 'package:look_talk/ui/main/community/post_create_screen.dart';
import 'package:look_talk/ui/main/community/post_detail_screen.dart';
import 'package:look_talk/ui/main/home/home_screen.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/mypage_screen.dart';
import 'package:look_talk/ui/main/mypage/mypage_seller/mypage_screen_seller.dart';
//import 'package:look_talk/ui/main/mypage/mypage_product/mypage_screen_seller.dart';
import 'package:look_talk/ui/product/product_detail/product_detail_screen.dart';
import 'package:look_talk/ui/main/wishlist/wishlist_screen.dart';
import 'package:look_talk/ui/search/search_screen.dart';
import 'package:look_talk/view_model/auth/auth_view_model.dart';
import 'package:look_talk/view_model/auth/nickname_check_view_model.dart';
import 'package:provider/provider.dart';

import '../../model/post_dummy.dart';
import '../../ui/auth/login_screen.dart';
import '../../ui/auth/seller_info_screen.dart';
import '../../ui/auth/signup_choice_screen.dart';
import '../../ui/auth/buyer_info_screen.dart';
import '../../ui/main/mypage/mypage_customer/notice.dart';
import '../../ui/main/mypage/mypage_seller/manage_product_seller_screen.dart';
import '../../ui/main/mypage/mypage_seller/mypage_screen_product_manage.dart';
import '../../view_model/viewmodel_provider.dart';
import '../network/token_storage.dart';

final GoRouter router = GoRouter(
  initialLocation: '/home',
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
      routes: [
        GoRoute(
          path: 'product-register',
          builder: (context, state) => ProductRegistrationScreen(),
        ),
      ],
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
    GoRoute(path: '/search', builder: (context, state) {
        return ChangeNotifierProvider(
          create: (_) => provideSearchScreenViewModel(),
          child: SearchScreen(),
        );
}
    ),
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
        // GoRoute(
        //   path: '/community',
        //   builder: (context, state) {
        //     print('라우트!!!!!!!!!!!!! 커뮤니티 라우트임!!! ');
        //     return FutureBuilder<String?>(
        //       future: TokenStorage().getUserId(),
        //       builder: (context, snapshot) {
        //         print("snapshot.connectionState: ${snapshot.connectionState}");
        //         print("snapshot.hasData: ${snapshot.hasData}");
        //         print("snapshot.data: ${snapshot.data}");
        //
        //         if (!snapshot.hasData) {return const Center(child: CommonLoading());}
        //
        //         final userId = snapshot.data!;
        //
        //         return MultiProvider(
        //           providers: [
        //             ChangeNotifierProvider(create: (_) => provideQuestionPostListViewModel()..fetchPosts(reset: true)),
        //             ChangeNotifierProvider(create: (_) => provideRecommendPostListViewModel()..fetchPosts(reset: true)),
        //             ChangeNotifierProvider(create: (_) => provideMyPostListViewModel(userId)..init()),
        //             ChangeNotifierProvider(create: (_) => provideCommunityTabViewModel()),
        //           ],
        //           child: const CommunityScreen(),
        //         );
        //       },
        //     );
        //   },
        // ),
        GoRoute(
          path: '/community',
          builder: (context, state) {
            print('라우트!!!!!!!!!!!!! 커뮤니티 라우트임!!!');
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
                // 👇 MyPostListViewModel 주입은 잠시 생략
                // ChangeNotifierProvider(
                //   create: (_) => provideMyPostListViewModel(userId)..init(),
                // ),
              ],
              child: const CommunityScreen(),
            );
          },
        ),

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
