import 'package:look_talk/model/client/buyer_signup_api_client.dart';
import 'package:look_talk/model/client/post_create_api_client.dart';
import 'package:look_talk/model/entity/response/bring_sub_category_response.dart';
import 'package:look_talk/model/client/seller_signup_api_client.dart';
import 'package:look_talk/model/repository/buyer_signup_repository.dart';
import 'package:look_talk/model/repository/category_detail_repository.dart';
import 'package:look_talk/model/repository/category_repository.dart';
import 'package:look_talk/model/repository/post_repository.dart';
import 'package:look_talk/model/repository/seller_signup_repository.dart';
import 'package:look_talk/view_model/auth/buyer_signup_view_model.dart';
import 'package:look_talk/view_model/category/category_data_select_viewmodel.dart';
import 'package:look_talk/view_model/category/category_detail/detail_listview_viewmodel.dart';
import 'package:look_talk/view_model/auth/seller_signup_view_model.dart';
import 'package:look_talk/view_model/community/community_product_tab_view_model.dart';
import 'package:look_talk/view_model/community/post_create_view_model.dart';
import 'package:look_talk/view_model/community/post_detail_view_model.dart';
import 'package:look_talk/view_model/search_view_model.dart';

import '../core/network/dio_client.dart';
import '../model/client/auth_api_client.dart';
import '../model/client/cart_api_client.dart';
import '../model/client/nickname_api_client.dart';
import '../model/client/order_api_client.dart';
import '../model/client/post_api_client.dart';
import '../model/repository/auth_repository.dart';
import '../model/repository/cart_repository.dart';
import '../model/repository/nickname_respository.dart';
import '../model/repository/order_repository.dart';
import '../model/repository/post_create_repository.dart';
import '../model/repository/search_repository.dart';
import 'auth/auth_view_model.dart';
import 'auth/nickname_check_view_model.dart';
import 'cart/cart_view_model.dart';
import 'community/community_tab_view_model.dart';
import 'community/my_post_list_view_model.dart';
import 'community/question_post_list_view_model.dart';
import 'community/recommend_post_list_view_model.dart';
import 'order/order_view_model.dart';
import 'package:look_talk/model/client/wishlist_api_client.dart';
import 'package:look_talk/model/repository/wishlist_repository.dart';
import 'wishlist/wishlist_view_model.dart';

final dio = DioClient.instance;

// 로그인 & 회원가입
AuthViewModel provideAuthViewModel() => AuthViewModel(AuthRepository(AuthApiClient(dio)));
NicknameCheckViewModel provideNicknameCheckViewModel() => NicknameCheckViewModel(NicknameRepository(NicknameApiClient(dio)));
BuyerSignupViewModel provideBuyerSignupViewModel() => BuyerSignupViewModel(BuyerSignupRepository(BuyerSignupApiClient(dio)));
SellerSignupViewmodel provideSellerSignupViewModel() => SellerSignupViewmodel(SellerSignupRepository(SellerSignupApiClient(dio)));

SearchViewModel provideSearchScreenViewModel() => SearchViewModel(repository: SearchRepository(dio));
CategoryDataSelectViewmodel provideCategoryDataSelectViewmodel() => CategoryDataSelectViewmodel(repository: CategoryRepository(dio));
DetailListviewViewmodel provideCategoryDetailViewModel({
  required List<BringSubCategoryResponse> subCategories,
  required BringSubCategoryResponse initialSubCategory,
  required BringSubCategoryResponse mainCategory,
}) =>
    DetailListviewViewmodel(
        repository: CategoryDetailRepository(dio),
        subCategories: subCategories,
        initialSubCategory: initialSubCategory,
        mainCategory: mainCategory
    );
CartViewModel provideCartViewModel() => CartViewModel(CartRepository(CartApiClient(dio)));
// [✅ 수정] 다른 Provider와 일관성을 맞추기 위해 DioClient() 직접 생성 대신 공용 dio 객체를 사용합니다.
OrderViewModel provideOrderViewModel() => OrderViewModel(OrderRepository(OrderApiClient(dio)));
WishlistViewModel provideWishlistViewModel() => WishlistViewModel(WishlistRepository(dio));



// 커뮤니티
CommunityTabViewModel provideCommunityTabViewModel() => CommunityTabViewModel();
QuestionPostListViewModel provideQuestionPostListViewModel() => QuestionPostListViewModel(PostRepository(PostApiClient(dio)));
RecommendPostListViewModel provideRecommendPostListViewModel() => RecommendPostListViewModel(PostRepository(PostApiClient(dio)));
MyPostListViewModel provideMyPostListViewModel(String userId) => MyPostListViewModel(PostRepository(PostApiClient(dio)), userId);
PostCreateViewModel providePostCreateViewModel() =>  PostCreateViewModel(PostCreateRepository(PostCreateApiClient(dio)));
PostDetailViewModel providerPostDetailViewModel(String postId) => PostDetailViewModel(PostRepository(PostApiClient(dio)), postId);
CommunityProductTabViewModel provideCommunityProductTabViewModel() => CommunityProductTabViewModel();