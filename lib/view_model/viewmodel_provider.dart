import 'package:look_talk/model/client/buyer_signup_api_client.dart';
import 'package:look_talk/model/client/post_create_api_client.dart';
import 'package:look_talk/model/client/seller_signup_api_client.dart';
import 'package:look_talk/model/entity/response/bring_sub_category_response.dart';
import 'package:look_talk/model/repository/alter_member_repository.dart';
import 'package:look_talk/model/repository/buyer_signup_repository.dart';
import 'package:look_talk/model/repository/category_detail_repository.dart';
import 'package:look_talk/model/repository/category_repository.dart';
import 'package:look_talk/model/repository/home_repository.dart';
import 'package:look_talk/model/repository/order_list_repository.dart';
import 'package:look_talk/model/repository/post_repository.dart';
import 'package:look_talk/model/repository/seller_signup_repository.dart';
import 'package:look_talk/view_model/auth/buyer_signup_view_model.dart';
import 'package:look_talk/view_model/auth/seller_signup_view_model.dart';
import 'package:look_talk/view_model/category/category_data_select_viewmodel.dart';
import 'package:look_talk/view_model/category/category_detail/detail_listview_viewmodel.dart';
import 'package:look_talk/view_model/community/community_product_tab_view_model.dart';
import 'package:look_talk/view_model/community/post_create_view_model.dart';
import 'package:look_talk/view_model/community/post_detail_view_model.dart';
import 'package:look_talk/view_model/home/home_category_viewmodel.dart';
import 'package:look_talk/view_model/inquiry/inquiry_viewmodel.dart';
import 'package:look_talk/view_model/mypage_view_model/alter_member_viewmodel.dart';
import 'package:look_talk/view_model/mypage_view_model/search_my_product_list_viewmodel.dart';
import 'package:look_talk/view_model/mypage_view_model/seller_manage_viewmodel.dart';
import 'package:look_talk/view_model/product/product_community_viewmodel.dart';
import 'package:look_talk/view_model/product/product_detail_viewmodel.dart';
import 'package:look_talk/view_model/product/product_list_viewmodel.dart';
import 'package:look_talk/view_model/product/product_post_list_viewmodel.dart';
import 'package:look_talk/view_model/product/product_register_viewmodel.dart';
import 'package:look_talk/view_model/search_view_model.dart';
import 'package:look_talk/view_model/community/category_post_list_viewmodel.dart';
import 'package:look_talk/view_model/wishlist/wishlist_view_model.dart';

import '../core/network/dio_client.dart';
import '../core/network/token_storage.dart';
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
import '../model/repository/product_repository.dart';
import '../model/repository/search_repository.dart';
import '../model/repository/wishlist_repository.dart';
import 'auth/auth_view_model.dart';
import 'auth/nickname_check_view_model.dart';
import 'cart/cart_view_model.dart';
import 'community/community_board_view_model.dart';
import 'community/community_tab_view_model.dart';
import 'community/my_post_list_view_model.dart';
import 'community/question_post_list_view_model.dart';
import 'community/recommend_post_list_view_model.dart';
import 'order/order_view_model.dart';

final dio = DioClient.instance;
final tokenStorage = TokenStorage();

// 로그인 & 회원가입
final authViewModel = provideAuthViewModel();
AuthViewModel provideAuthViewModel() => AuthViewModel(AuthRepository(AuthApiClient(dio)));
CheckNameViewModel provideCheckNameViewModel() => CheckNameViewModel(CheckNameRepository(CheckNameApiClient(dio)));
BuyerSignupViewModel provideBuyerSignupViewModel() => BuyerSignupViewModel(BuyerSignupRepository(BuyerSignupApiClient(dio)));
SellerSignupViewmodel provideSellerSignupViewModel() => SellerSignupViewmodel(SellerSignupRepository(SellerSignupApiClient(dio)));

// 검색 & 장바구니
SearchViewModel provideSearchScreenViewModel() => SearchViewModel(repository: SearchRepository(dio));
CategoryDataSelectViewmodel provideCategoryDataSelectViewmodel() => CategoryDataSelectViewmodel(repository: CategoryRepository(dio));
DetailListviewViewmodel provideCategoryDetailViewModel({
  required List<BringSubCategoryResponse> subCategories,
  required BringSubCategoryResponse initialSubCategory,
  required BringSubCategoryResponse mainCategory,
}) => DetailListviewViewmodel(
    repository: CategoryDetailRepository(dio),
    subCategories: subCategories,
    initialSubCategory: initialSubCategory,
    mainCategory: mainCategory
);
CartViewModel provideCartViewModel() => CartViewModel(CartRepository(CartApiClient(dio)));
WishlistViewModel provideWishlistViewModel() => WishlistViewModel(WishlistRepository(dio));
// 주문
OrderViewModel provideOrderViewModel() => OrderViewModel(OrderRepository(OrderApiClient(dio)));

// 커뮤니티
CommunityTabViewModel provideCommunityTabViewModel() => CommunityTabViewModel();
QuestionPostListViewModel provideQuestionPostListViewModel() => QuestionPostListViewModel(PostRepository(PostApiClient(dio)));
RecommendPostListViewModel provideRecommendPostListViewModel() => RecommendPostListViewModel(PostRepository(PostApiClient(dio)));
MyPostListViewModel provideMyPostListViewModel(String userId) => MyPostListViewModel(PostRepository(PostApiClient(dio)), userId);
PostCreateViewModel providePostCreateViewModel() => PostCreateViewModel(PostCreateRepository(PostCreateApiClient(dio)));
PostDetailViewModel providerPostDetailViewModel(String postId) => PostDetailViewModel(PostRepository(PostApiClient(dio)), tokenStorage, postId);
CommunityBoardViewModel provideCommunityBoardViewModel(String category, {String? productId}) =>
    CommunityBoardViewModel(
      repository: PostRepository(PostApiClient(dio)),
      category: category,
      productId: productId,
    );
ProductPostListViewModel provideProductPostListViewModel(String productId) =>
    ProductPostListViewModel(PostRepository(PostApiClient(dio)), productId);
CommunityProductTabViewModel provideCommunityProductTabViewModel() => CommunityProductTabViewModel();
CategoryPostListViewModel provideCategoryPostListViewModel(String category, {String? productId}) {
  return CategoryPostListViewModel(PostRepository(PostApiClient(dio)), category, productId: productId);
}

ProductViewModel provideProductViewModel() => ProductViewModel(ProductRepository(dio));
ProductRegisterViewModel provideProductRegisterViewModel() => ProductRegisterViewModel(dio);
ProductDetailViewModel provideProductDetailViewModel(String productId) =>
    ProductDetailViewModel(ProductRepository(dio), productId);
InquiryViewModel provideInquiryViewModel() => InquiryViewModel();
ProductCommunityViewModel provideProductCommunityViewModel(String productId) =>
    ProductCommunityViewModel(repository: PostRepository(PostApiClient(dio)), productId: productId);

// 마이페이지
AlterMemberViewmodel provideAlterMemberViewmodel() => AlterMemberViewmodel(repository: AlterMemberRepository(dio));
SearchMyProductListViewmodel provideSearchMyProductListViewmodel() => SearchMyProductListViewmodel(repository: OrderListRepository(dio));
SellerManageViewmodel provideSellerManageViewmodel() => SellerManageViewmodel(repository: OrderListRepository(dio));

// 홈화면
HomeCategoryViewModel provideHomeViewModelDefault() {
  final categoryRepository = CategoryRepository(dio);
  final categoryDetailRepository = CategoryDetailRepository(dio);
  final homeRepository = HomeRepository(dio, categoryDetailRepository, categoryRepository);
  return HomeCategoryViewModel(homeRepository);
}
