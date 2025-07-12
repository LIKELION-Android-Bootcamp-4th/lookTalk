import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../view_model/auth/auth_view_model.dart';

Future<void> navigateWithAuthCheck({
  required BuildContext context,
  required String destinationIfLoggedIn,
  required String fallbackIfNotLoggedIn,
}) async {
  final authViewModel = context.read<AuthViewModel>();
  final isLoggedIn = await authViewModel.isLoggedIn();

  if (isLoggedIn) {
    context.push(destinationIfLoggedIn);
    print('로그인 되어있는 상태!!!!!!');
  } else {
    context.push(fallbackIfNotLoggedIn);
    print('로그인 안되어있는 상태!!!!!!!');
  }
}
