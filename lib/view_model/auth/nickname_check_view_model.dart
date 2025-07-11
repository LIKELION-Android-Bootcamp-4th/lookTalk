import 'dart:async';
import 'package:flutter/material.dart';
import '../../model/entity/request/nickname_request.dart';
import '../../model/entity/response/nickname_check_response.dart';
import '../../model/repository/nickname_respository.dart';
import '../../core/network/api_result.dart';

// 닉네임 중복 확인 요청 보내고 결과 관리
class NicknameCheckViewModel extends ChangeNotifier {
  final NicknameRepository _repository;

  NicknameCheckViewModel(this._repository);

  NicknameCheckResponse? _nicknameResult;
  String? _errorMessage;
  bool _isLoading = false;
  Timer? _debounce;

  NicknameCheckResponse? get nicknameResult => _nicknameResult;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool? get isAvailable => _nicknameResult?.available;

  void checkNickname(String nickname) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () async {
      _isLoading = true;
      _nicknameResult = null;
      _errorMessage = null;
      notifyListeners();

      final request = NicknameCheckRequest(nickname: nickname);

      final result = await _repository.checkNickname(request);

      if (result.success) {
        _nicknameResult = result.data;
        _errorMessage = null;
      } else {
        _nicknameResult = null;
        _errorMessage = result.message.isNotEmpty
            ? result.message
            : '닉네임 확인 중 오류 발생';
      }

      _isLoading = false;
      notifyListeners();
    });
  }

  void reset() {
    _nicknameResult = null;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
