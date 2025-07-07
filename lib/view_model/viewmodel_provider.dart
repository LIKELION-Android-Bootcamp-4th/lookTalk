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

