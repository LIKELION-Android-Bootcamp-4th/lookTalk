import 'package:look_talk/model/client/buyer_signup_api_client.dart';
import 'package:look_talk/model/client/post_create_api_client.dart';
import 'package:look_talk/model/repository/buyer_signup_repository.dart';
import 'package:look_talk/model/repository/post_repository.dart';
import 'package:look_talk/view_model/auth/buyer_signup_view_model.dart';
import 'package:look_talk/view_model/community/post_create_view_model.dart';
import 'package:look_talk/view_model/community/post_detail_view_model.dart';
import 'package:look_talk/view_model/search_view_model.dart';
import 'package:look_talk/view_model/product/product_list_viewmodel.dart';
import 'package:look_talk/view_model/product/product_register_viewmodel.dart';
import 'package:look_talk/view_model/search_view_model.dart';

import '../core/network/dio_client.dart';
import '../model/client/auth_api_client.dart';
import '../model/client/nickname_api_client.dart';
import '../model/client/post_api_client.dart';
import '../model/repository/auth_repository.dart';
import '../model/repository/nickname_respository.dart';
import '../model/repository/post_create_repository.dart';
import '../model/repository/product_repository.dart';
import '../model/repository/search_repository.dart';
import 'auth/auth_view_model.dart';
import 'auth/nickname_check_view_model.dart';
import 'community/community_tab_view_model.dart';
import 'community/my_post_list_view_model.dart';
import 'community/question_post_list_view_model.dart';
import 'community/recommend_post_list_view_model.dart';
import 'package:look_talk/view_model/home/home_product_list_viewmodel.dart';
import 'package:look_talk/view_model/home/home_category_viewmodel.dart';
import 'package:look_talk/view_model/product/product_detail_viewmodel.dart';


final dio = DioClient.instance;


AuthViewModel provideAuthViewModel() => AuthViewModel(AuthRepository(AuthApiClient(dio)));
NicknameCheckViewModel provideNicknameCheckViewModel() => NicknameCheckViewModel(NicknameRepository(NicknameApiClient(dio)));
BuyerSignupViewModel provideBuyerSignupViewModel() => BuyerSignupViewModel(BuyerSignupRepository(BuyerSignupApiClient(dio)));
SearchViewModel provideSearchScreenViewModel() => SearchViewModel(repository: SearchRepository(dio));

// 커뮤니티
CommunityTabViewModel provideCommunityTabViewModel() => CommunityTabViewModel();
QuestionPostListViewModel provideQuestionPostListViewModel() => QuestionPostListViewModel(PostRepository(PostApiClient(dio)));
RecommendPostListViewModel provideRecommendPostListViewModel() => RecommendPostListViewModel(PostRepository(PostApiClient(dio)));
MyPostListViewModel provideMyPostListViewModel(String userId) => MyPostListViewModel(PostRepository(PostApiClient(dio)), userId);
PostCreateViewModel providePostCreateViewModel() =>  PostCreateViewModel(PostCreateRepository(PostCreateApiClient(dio)));
PostDetailViewModel providerPostDetailViewModel(String postId) => PostDetailViewModel(PostRepository(PostApiClient(dio)), postId);

// 상품관리
ProductViewModel provideProductViewModel() => ProductViewModel(dio)..fetchProducts();
ProductRegisterViewModel provideProductRegisterViewModel() => ProductRegisterViewModel(dio);
ProductDetailViewModel provideProductDetailViewModel(String productId) => ProductDetailViewModel(ProductRepository(dio), productId);

HomeProductListViewModel provideHomeProductListViewModel() => HomeProductListViewModel(dio)..fetchProducts();
HomeCategoryViewModel provideHomeCategoryViewModel() => HomeCategoryViewModel();


