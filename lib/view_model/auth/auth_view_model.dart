import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/network/token_storage.dart';
import 'package:look_talk/ui/common/component/common_loading.dart';
import '../../model/entity/request/social_login_request.dart';
import '../../model/repository/auth_repository.dart';
import '../../model/entity/response/user.dart';

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

  /// ✅ 소셜 로그인 후 서버에 가입 여부 확인
  Future<void> handleSocialLogin(BuildContext context, AuthInfo authInfo, String provider) async {
    _tempAuthInfo = authInfo;
    _tempProvider = provider;
    notifyListeners();

    final navigator = Navigator.of(context);
    navigator.push(MaterialPageRoute(builder: (_) => const CommonLoading()));

    try {
      final request = SocialLoginRequest(
        provider: provider,
        platformRole: null, // 역할 미지정
        authInfo: authInfo,
      );

      final result = await repository.loginWithSocial(request: request);

      if (context.mounted) Navigator.of(context).pop();

      if (result.success && result.data != null) {
        final user = result.data!.user;

        // ✅ 기존 가입자: 바로 로그인
        if (user.mainRole != null && user.mainRole!.isNotEmpty) {
          await _tokenStorage.saveTokens(
            accessToken: result.data!.accessToken,
            refreshToken: result.data!.refreshToken,
            userId: user.id,
            companyCode: user.companyCode ?? '6866fcea5b230f5dc709bdeb',
          );
          await _tokenStorage.saveUserRole(user.mainRole!);
          _currentUser = user;
          _userRole = user.mainRole;
          _tempAuthInfo = null;
          _tempProvider = null;
          notifyListeners();
          context.go('/home');
        } else {

          if(context.canPop()){
            context.pop(); // TODO: 이전 화면으로 잘 가는지 확인
          }else{
            context.go('/home'); // TODO : 이전에 있던 화면으로...!?
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message)));
      }
    } catch (e) {
      if (navigator.canPop()) navigator.pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('서버 연결 실패')));
    }
  }

  Future<void> completeSignup(BuildContext context, String role) async {
    if (_tempAuthInfo == null || _tempProvider == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 정보가 만료되었습니다. 다시 시도해주세요.')),
      );
      context.go('/login');
      return;
    }

    final navigator = Navigator.of(context);
    navigator.push(MaterialPageRoute(builder: (_) => const CommonLoading()));

    try {
      final request = SocialLoginRequest(
        provider: _tempProvider!,
        platformRole: role,
        authInfo: _tempAuthInfo!,
      );

      final result = await repository.loginWithSocial(request: request);
      if (context.mounted) Navigator.of(context).pop();

      if (result.success && result.data != null) {
        await _tokenStorage.saveTokens(
          accessToken: result.data!.accessToken,
          refreshToken: result.data!.refreshToken,
          userId: result.data!.user.id,
          companyCode: '6866fcea5b230f5dc709bdeb',
        );

        await _tokenStorage.saveUserRole(role);
        _userRole = role;
        _currentUser = result.data!.user;
        _tempAuthInfo = null;
        _tempProvider = null;
        notifyListeners();

        context.go('/mypage');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.message)));
      }
    } catch (e) {
      if (navigator.canPop()) navigator.pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('서버 연결 실패')));
    }
  }

  Future<void> logout(BuildContext context) async {
    await _tokenStorage.deleteTokens();
    await _tokenStorage.clearUserRole();
    _currentUser = null;
    _userRole = null;
    notifyListeners();
    if (context.mounted) {
      context.go('/login');
    }
  }
}
