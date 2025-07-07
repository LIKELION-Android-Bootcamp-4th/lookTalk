import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/entity/request/buyer_signup_request.dart';
import '../../model/repository/buyer_signup_repository.dart';

class BuyerSignupViewModel extends ChangeNotifier{
  final BuyerSignupRepository _repository;

  BuyerSignupViewModel(this._repository);

  Future<void> submitSignup({
    required BuildContext context,
    required String nickName,
  }) async {
    final request = BuyerSignupRequest(nickName: nickName);

    final result = await _repository.submitBuyerSignup(request: request);

    if (result.success) {
      // 성공 시: 홈으로 이동
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
      context.go('/home');
    } else {
      // 실패 시: 실패 메시지 출력
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
    }
  }
}