
import 'package:look_talk/model/repository/search_repository.dart';
import 'package:look_talk/view_model/search_view_model.dart';
import 'package:look_talk/model/client/buyer_signup_api_client.dart';
import 'package:look_talk/model/repository/buyer_signup_repository.dart';
import 'package:look_talk/view_model/auth/buyer_signup_view_model.dart';
import 'package:look_talk/view_model/cart/cart_view_model.dart';

import '../core/network/dio_client.dart';
import '../model/client/auth_api_client.dart';
import '../model/client/cart_api_client.dart'; // [✅ CartApiClient 임포트 추가]
import '../model/client/nickname_api_client.dart';
import '../model/repository/auth_repository.dart';
import '../model/repository/cart_repository.dart';
import '../model/repository/nickname_respository.dart';
import 'auth/auth_view_model.dart';
import 'auth/nickname_check_view_model.dart';

final dio = DioClient.instance;


AuthViewModel provideAuthViewModel() => AuthViewModel(AuthRepository(AuthApiClient(dio)));
NicknameCheckViewModel provideNicknameCheckViewModel() => NicknameCheckViewModel(NicknameRepository(NicknameApiClient(dio)));

SearchViewModel provideSearchScreenViewModel() => SearchViewModel(repository: SearchRepository(dio));

BuyerSignupViewModel provideBuyerSignupViewModel() => BuyerSignupViewModel(BuyerSignupRepository(BuyerSignupApiClient(dio)));

// [✅ CartViewModel 생성 로직을 올바르게 수정]
// CartRepository는 CartApiClient를 필요로 하고, CartViewModel은 이 Repository를 받습니다.
CartViewModel provideCartViewModel() => CartViewModel(CartRepository(CartApiClient(DioClient())));