import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/network/token_storage.dart';
import 'package:look_talk/ui/common/component/common_loading.dart';
import '../../model/entity/request/social_login_request.dart';
import '../../model/repository/auth_repository.dart';
import '../../model/entity/response/user.dart';
import '../../ui/common/component/common_snack_bar.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository repository;
  final TokenStorage _tokenStorage = TokenStorage();

  AuthViewModel(this.repository) {
    checkLoginStatus();
  }

  User? _currentUser;
  AuthInfo? _tempAuthInfo;
  String? _tempProvider;
  String? _userRole;

  User? get currentUser => _currentUser;

  AuthInfo? get tempAuthInfo => _tempAuthInfo;

  String? get tempProvider => _tempProvider;

  String get userRole => _userRole ?? 'buyer';

  bool get isLoggedIn => _currentUser != null;

  Future<bool> isLoggedInForGuard() async {
    final accessToken = await _tokenStorage.getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }

  Future<void> checkLoginStatus() async {
    final token = await _tokenStorage.getAccessToken();
    final role = await _tokenStorage.loadUserRole();
    _userRole = role;

    if (token != null && token.isNotEmpty) {
      final result = await repository.getUserInfo();
      if (result.success && result.data != null) {
        _currentUser = result.data;
        _userRole ??= _currentUser?.mainRole;
      } else {
        _currentUser = null;
        await _tokenStorage.deleteTokens();
        await _tokenStorage.clearUserRole();
      }
    } else {
      _currentUser = null;
    }
    notifyListeners();
  }

  Future<void> handleSocialLogin(
    BuildContext context,
    AuthInfo authInfo,
    String provider,
  ) async {
    _tempAuthInfo = authInfo;
    _tempProvider = provider;
    notifyListeners();

    final navigator = Navigator.of(context);
    navigator.push(MaterialPageRoute(builder: (_) => const CommonLoading()));

    try {
      final request = SocialLoginRequest(
        provider: provider,
        platformRole: 'buyer',
        authInfo: authInfo,
      );

      final result = await repository.loginWithSocial(request: request);

      if (context.mounted) Navigator.of(context).pop();

      if (result.success && result.data != null) {
        final user = result.data!.user;

        await _tokenStorage.saveTokens(
          accessToken: result.data!.accessToken,
          refreshToken: result.data!.refreshToken,
          userId: user.id,
          companyCode: user.companyCode ?? '6866fcea5b230f5dc709bdeb',
        );
        await _tokenStorage.saveUserRole(user.mainRole ?? 'buyer');

        if (user.isNewUser) {
          _tempAuthInfo = authInfo;
          _tempProvider = provider;
          _currentUser = null;
          notifyListeners();
          context.go('/signup');
          return;
        } else {
          print(' 신규 유저 아님!!! ');
        }

        _currentUser = user;
        _userRole = user.mainRole;
        _tempAuthInfo = null;
        _tempProvider = null;
        notifyListeners();

        context.go('/home');
      } else {
        CommonSnackBar.show(context, message: '${result.message}');
      }
    } catch (e) {
      if (navigator.canPop()) navigator.pop();
      CommonSnackBar.show(context, message: '서버 연결 실패');
    }
  }

  Future<void> logout(BuildContext context) async {
    await _tokenStorage.deleteTokens();
    await _tokenStorage.clearUserRole();
    _currentUser = null;
    _userRole = null;
    notifyListeners();
    if (context.mounted) {
      context.go('/home');
    }
  }
}
