import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/network/api_result.dart';
import '../../model/entity/request/buyer_signup_request.dart';
import '../../model/repository/buyer_signup_repository.dart';

class BuyerSignupViewModel extends ChangeNotifier {
  final BuyerSignupRepository _repository;

  BuyerSignupViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // 회원가입 요청
  Future<ApiResult<void>> submitSignup(String nickname) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final request = BuyerSignupRequest(nickName: nickname);

    try {
      final result = await _repository.submitBuyerSignup(request: request);
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      _errorMessage = '회원가입 중 오류가 발생했습니다.';
      notifyListeners();
      return ApiResult(
        success: false,
        message: _errorMessage!,
        data: null,
        timestamp: DateTime.now(),
        error: e.toString(),
      );
    }
  }

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }
}
