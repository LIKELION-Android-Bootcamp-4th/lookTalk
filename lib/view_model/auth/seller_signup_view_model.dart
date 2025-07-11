import 'package:flutter/material.dart';
import 'package:look_talk/model/repository/seller_signup_repository.dart';

import '../../core/network/api_result.dart';
import '../../model/entity/request/seller_signup_request.dart';

class SellerSignupViewmodel extends ChangeNotifier {
  final SellerSignupRepository _repository;

  SellerSignupViewmodel(this._repository){
    nameController.addListener(() {
      notifyListeners();
    });
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  @override
  void dispose() {
    nameController.dispose(); // 메모리 누수 방지
    descriptionController.dispose();
    super.dispose();
  }

  // 회원가입 요청
  Future<ApiResult<void>> submitSignup(String name, String description) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    //final name = nameController.text.trim();
    final request = SellerSignupRequest(name: name, description: description);

    if (name.isEmpty) {
      return ApiResult(
        success: false,
        message: '회사명을 입력해주세요.',
        data: null,
        timestamp: DateTime.now(),
      );
    }

    try {
      final result = await _repository.submitSellerSignup(request: request);
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
