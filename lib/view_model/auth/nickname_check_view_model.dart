import 'dart:async';
import 'package:flutter/material.dart';
import '../../model/entity/request/nickname_request.dart';
import '../../model/entity/response/nickname_check_response.dart';
import '../../model/repository/nickname_respository.dart';
import '../../core/network/api_result.dart';

// // 닉네임 중복 확인 요청 보내고 결과 관리
// class NicknameCheckViewModel extends ChangeNotifier {
//   final NicknameRepository _repository;
//
//   NicknameCheckViewModel(this._repository);
//
//   NicknameCheckResponse? _nicknameResult;
//   String? _errorMessage;
//   bool _isLoading = false;
//   Timer? _debounce;
//
//   NicknameCheckResponse? get nicknameResult => _nicknameResult;
//   String? get errorMessage => _errorMessage;
//   bool get isLoading => _isLoading;
//   bool? get isAvailable => _nicknameResult?.available;
//
//   void checkNickname(String nickname) {
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 700), () async {
//       _isLoading = true;
//       _nicknameResult = null;
//       _errorMessage = null;
//       notifyListeners();
//
//       final request = NicknameCheckRequest(nickname: nickname);
//
//       final result = await _repository.checkNickname(request);
//
//       if (result.success) {
//         _nicknameResult = result.data;
//         _errorMessage = null;
//       } else {
//         _nicknameResult = null;
//         _errorMessage = result.message.isNotEmpty
//             ? result.message
//             : '닉네임 확인 중 오류 발생';
//       }
//
//       _isLoading = false;
//       notifyListeners();
//     });
//   }
//
//   void reset() {
//     _nicknameResult = null;
//     _errorMessage = null;
//     notifyListeners();
//   }
//
//   @override
//   void dispose() {
//     _debounce?.cancel();
//     super.dispose();
//   }
// }

class CheckNameViewModel extends ChangeNotifier{
  final CheckNameRepository _repository;

  CheckNameViewModel(this._repository);

  CheckNameResponse? _result;
  String? _errorMessage;
  bool _isLoading = false;
  Timer? _debounce;

  CheckNameResponse? get result => _result;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool? get isAvailable => _result?.available;

  // void check(CheckNameType type, String value) {
  //   _debounce?.cancel();
  //   _debounce = Timer(const Duration(milliseconds: 700), () async {
  //     _isLoading = true;
  //     _result = null;
  //     _errorMessage = null;
  //     notifyListeners();
  //
  //     final request = CheckNameRequest(type: type, value: value);
  //     final result = await _repository.check(request);
  //
  //     _result = result.data;
  //
  //     if (!result.success) {
  //       _errorMessage = result.message.isNotEmpty
  //           ? result.message
  //           : '중복 확인 중 오류 발생';
  //     } else {
  //       _errorMessage = null;
  //     }
  //
  //     // if (result.success) {
  //     //   _result = result.data;
  //     //   _errorMessage = null;
  //     // } else {
  //     //   _result = null;
  //     //   _errorMessage =
  //     //   result.message.isNotEmpty ? result.message : '중복 확인 중 오류 발생';
  //     // }
  //
  //     _isLoading = false;
  //     notifyListeners();
  //   });
  // }

  void check(CheckNameType type, String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () async {
      _isLoading = true;
      _result = null;
      _errorMessage = null;
      notifyListeners();

      final request = CheckNameRequest(type: type, value: value.trim());

      try {
        final result = await _repository.check(request);

        if (result.success && result.data != null) {
          _result = result.data;
          _errorMessage = null;
        } else {
          _result = null;
          _errorMessage = result.message.isNotEmpty
              ? result.message
              : '중복 확인 중 오류 발생';
        }
      } catch (e, stackTrace) {
        // 예외가 발생하면 로그 찍고 상태 업데이트
        debugPrint('[CheckNameViewModel] 예외 발생: $e\n$stackTrace');
        _result = null;
        _errorMessage = '서버와 통신 중 오류가 발생했습니다.';
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    });
  }


  void reset() {
    _result = null;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

}