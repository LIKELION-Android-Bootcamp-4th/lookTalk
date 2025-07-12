import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/model/entity/response/bring_sub_category_response.dart';
import 'package:look_talk/ui/cart/cart_screen.dart';
import 'package:look_talk/ui/main/bottom_nav_screen.dart';
import 'package:look_talk/ui/main/category/category/category_screen.dart';
import 'package:look_talk/ui/main/category/categorydetail/category_detail_screen.dart';
import 'package:look_talk/ui/main/community/community_entry_point.dart';
import 'package:look_talk/ui/main/community/post_create_screen.dart';
import 'package:look_talk/ui/main/community/post_detail_screen.dart';
import 'package:look_talk/ui/main/home/home_screen.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/alter_member.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/mypage_screen.dart';
//import 'package:look_talk/ui/main/mypage/mypage_product/mypage_screen_seller.dart';

import 'package:look_talk/ui/main/wishlist/wishlist_screen.dart';
import 'package:look_talk/ui/search/search_screen.dart';
import 'package:provider/provider.dart';

import '../../ui/auth/buyer_info_screen.dart';
import '../../ui/auth/login_screen.dart';
import '../../ui/auth/seller_info_screen.dart';
import '../../ui/auth/signup_choice_screen.dart';
import '../../ui/main/community/communication_product_registration/product_registration_screen.dart';
import '../../ui/main/mypage/mypage_customer/notice.dart';
import '../../ui/main/mypage/mypage_seller/manage_product_seller_screen.dart';
import '../../ui/main/mypage/mypage_seller/mypage_screen_product_manage.dart';
import '../../view_model/viewmodel_provider.dart';

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
          builder: (context, state) {
            return MultiProvider(
              providers: [
                // TODO : 회사명 중복 체크 추가
                ChangeNotifierProvider(
                  create: (_) => provideSellerSignupViewModel(),
                ),
              ],
              child: const SellerInfoScreen(),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/community/write',
      builder: (context, state) =>  PostCreateScreen(),
      routes: [
        GoRoute(
          path: 'product-register',
          builder: (context, state) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => provideCommunityProductTabViewModel()),
              ChangeNotifierProvider(create: (_) => provideSearchScreenViewModel()),
            ],
            child: const ProductRegistrationScreen(),
          ),
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
    GoRoute(
      path: '/search',
      builder: (context, state) {
        return ChangeNotifierProvider(
          create: (_) => provideSearchScreenViewModel(),
          child: SearchScreen(),
        );
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) {
        return ChangeNotifierProvider(
          create: (_) => provideCartViewModel(),
          child: CartScreen(),
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
           builder: (context, state) {
             return ChangeNotifierProvider(
               create: (_) => provideCategoryDataSelectViewmodel(),
               child: CategoryScreen(),
             );
           }
         ),
        GoRoute(
          path: '/categoryDetail',
          name: 'categoryDetail',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>;
            final subCategories = extra['subCategories'] as List<BringSubCategoryResponse>;
            final selected = extra['selectedSubCategory'] as BringSubCategoryResponse;
            final mainCategory = extra['mainCategory'] ;


            return ChangeNotifierProvider(
              create: (_) => provideCategoryDetailViewModel(
                subCategories: subCategories,
                initialSubCategory: selected,
                mainCategory: mainCategory

              ),
              child: CategoryDetailScreen(),
            );
          },
        ),
        GoRoute(
          path: '/community',
          builder: (context, state) => const CommunityEntryPoint()
        ),

        GoRoute(
          path: '/category',
          builder: (context, state) => CategoryScreen(),
        ),
        GoRoute(
          path: '/community',
          builder: (context, state) => const CommunityEntryPoint(),
        ),
        GoRoute(
          path: '/wishlist',
          builder: (context, state) {
            return ChangeNotifierProvider(
              // [✅ 수정] ..init() 호출 부분을 제거합니다.
              create: (_) => provideWishlistViewModel(),
              child: const WishlistScreen(),
            );
          },
        ),
        GoRoute(
          path: '/mypage',
          builder: (context, state) => const MyPageScreenCustomer(),
        ),

        GoRoute(path: '/alterMember',
        builder: (context,state) {
          return ChangeNotifierProvider(create: (_) =>
              provideAlterMemberViewmodel(),
            child: AlterMember(), );
        }),
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
