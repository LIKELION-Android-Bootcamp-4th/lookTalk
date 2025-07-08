
import 'package:look_talk/model/repository/search_repository.dart';
import 'package:look_talk/view_model/search_view_model.dart';
import 'package:look_talk/model/client/buyer_signup_api_client.dart';
import 'package:look_talk/model/repository/buyer_signup_repository.dart';
import 'package:look_talk/view_model/auth/buyer_signup_view_model.dart';
import '../core/network/dio_client.dart';
import '../model/client/auth_api_client.dart';
import '../model/client/nickname_api_client.dart';
import '../model/repository/auth_repository.dart';
import '../model/repository/nickname_respository.dart';
import 'auth/auth_view_model.dart';
import 'auth/nickname_check_view_model.dart';

final dio = DioClient.instance;


AuthViewModel provideAuthViewModel() => AuthViewModel(AuthRepository(AuthApiClient(dio)));
NicknameCheckViewModel provideNicknameCheckViewModel() => NicknameCheckViewModel(NicknameRepository(NicknameApiClient(dio)));

SearchViewModel provideSearchScreenViewModel() => SearchViewModel(repository: SearchRepository(dio));

BuyerSignupViewModel provideBuyerSignupViewModel() => BuyerSignupViewModel(BuyerSignupRepository(BuyerSignupApiClient(dio)));

