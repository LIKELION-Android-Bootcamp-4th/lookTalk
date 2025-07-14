import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import 'package:look_talk/model/entity/response/bring_sub_category_response.dart';
import 'package:look_talk/model/repository/category_detail_repository.dart';
import 'package:look_talk/model/repository/category_repository.dart';
import 'package:look_talk/ui/cart/cart_screen.dart';
import 'package:look_talk/ui/main/bottom_nav_screen.dart';
import 'package:look_talk/ui/main/category/category/category_screen.dart';
import 'package:look_talk/ui/main/category/categorydetail/category_detail_screen.dart';
import 'package:look_talk/ui/main/community/community_entry_point.dart';
import 'package:look_talk/ui/main/community/post_create_screen.dart';
import 'package:look_talk/ui/main/community/post_detail_screen.dart';
import 'package:look_talk/ui/main/home/home_screen.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/alter_member.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/manage_product/manage_product_screen.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/mypage_screen.dart';

import 'package:look_talk/ui/main/wishlist/wishlist_screen.dart';
import 'package:look_talk/ui/search/search_screen.dart';
import 'package:look_talk/view_model/home/home_category_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../ui/auth/buyer_info_screen.dart';
import '../../ui/auth/login_screen.dart';
import '../../ui/auth/seller_info_screen.dart';
import '../../ui/auth/signup_choice_screen.dart';
import '../../ui/main/community/communication_product_registration/product_registration_screen.dart';
import '../../ui/main/community/community_board_screen.dart';
import '../../ui/main/mypage/mypage_customer/notice.dart';
import '../../ui/main/mypage/mypage_seller/manage_product_seller_screen.dart';
import '../../ui/main/mypage/mypage_seller/mypage_screen_product_manage.dart';
import '../../ui/main/mypage/mypage_seller/mypage_screen_seller.dart';
import '../../ui/product/product_detail/product_detail_screen.dart';
import 'package:look_talk/ui/product/inquiry/inquiry_screen.dart';
// 뷰모델 및 프로바이더
import '../../view_model/viewmodel_provider.dart';
import '../../view_model/auth/auth_view_model.dart';

final authViewModel = provideAuthViewModel();


final _categoryDetailRepository = CategoryDetailRepository(dio);
final _categoryRepository = CategoryRepository(dio);

final GoRouter router = GoRouter(
  initialLocation: '/home',
  refreshListenable: authViewModel,

  redirect: (BuildContext context, GoRouterState state) {
    final authViewModel = context.read<AuthViewModel>();

    final isLoggedIn = authViewModel.isLoggedIn;
    final isGoingToLogin = state.matchedLocation == '/login';
    final isGoingToSignup = state.matchedLocation.startsWith('/signup');
    final isGoingToMyPage = state.matchedLocation == '/mypage';

    if (!isLoggedIn && isGoingToMyPage) return '/login';
    if (!isLoggedIn && !isGoingToLogin && !isGoingToSignup) return null;
    if (isLoggedIn && isGoingToLogin) return '/home';

    return null;
  },

  routes: <RouteBase>[
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
                // ChangeNotifierProvider(
                //   create: (_) => provideCheckNameViewModel(),
                // ),
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
                // ChangeNotifierProvider(create: (_) => provideCheckNameViewModel()),
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
      path: '/product/:id/inquiry',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;
        return ChangeNotifierProvider(
          create: (_) => provideInquiryViewModel(),  // InquiryViewModel 제공
          child:  InquiryScreen(),  // InquiryScreen을 해당 경로에 연결
        );
      },
    ),

    GoRoute(
      path: '/community/board/:category',
      builder: (context, state) {
        final category = state.pathParameters['category']!;
        final productId = state.uri.queryParameters['productId']; // ✅ 추가

        return ChangeNotifierProvider(
          create: (_) => provideCommunityBoardViewModel(category, productId: productId),
          child: CommunityBoardScreen(category: category),
        );
      },
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

    GoRoute(path: '/search', builder: (context, state) => ChangeNotifierProvider(
      create: (_) => provideSearchScreenViewModel(),
      child: SearchScreen(),
    )),

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

    GoRoute(
      path: '/seller/products',
      builder: (context, state) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => provideProductViewModel()),
          ChangeNotifierProvider(create: (_) => provideProductRegisterViewModel()),
        ],
        child: const MyPageProductManageScreen(),
      ),
    ),

    // GoRoute(path: '/seller/orders', builder: (context, state) => const ManageProductSellerScreen()),
    GoRoute(path: '/notice', builder: (context, state) => const NoticeScreen()),

    ShellRoute(
      builder: (context, state, child) => BottomNavScreen(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: child,
        ),
      ),
      routes: [

        GoRoute(path: '/home', builder: (context, state){
          return ChangeNotifierProvider(
              create:(_) => provideHomeViewModelDefault(),
          child: const HomeScreen(),);

} ),
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
          path: '/wishlist',
          builder: (context, state) => const WishlistScreen(),
        ),
        GoRoute(
          path: '/mypage',
          builder: (context, state) {
            return ChangeNotifierProvider(
              create: (_) => provideAlterMemberViewmodel(),
              builder: (context, child) {
                final authViewModel = context.watch<AuthViewModel>();

                if (!authViewModel.isLoggedIn) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.go('/login');
                  });
                  return const SizedBox.shrink();
                }

                print('유저 롤!!! : ${authViewModel.userRole}');

                return authViewModel.userRole == 'seller'
                    ? const MyPageScreenSeller()
                    : const MyPageScreenCustomer();
              },
            );
          },
        ),

        GoRoute(path: '/manageProduct',
            builder: (context,state) {
              return ChangeNotifierProvider(create: (_) =>
                 provideSearchMyProductListViewmodel(),
                child: ManageProductScreen(), );
            }),


        GoRoute(path: '/alterMember',
        builder: (context,state) {
          return MultiProvider(
              providers :[
              ChangeNotifierProvider(create: (_) => provideAlterMemberViewmodel()),
              ChangeNotifierProvider(create: (_) => provideBuyerSignupViewModel()),
              ],
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
          builder: (context, state) {
            return ChangeNotifierProvider(create: (_) =>provideSellerManageViewmodel(),
            child: ManageProductSellerScreen(),);
          },
        ),
      ],
    ),
  ],
);
