import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';

import '../const/colors.dart';

class CommonSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    final snackBar = SnackBar(
      content: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          message,
          style: context.bodyBold.copyWith(color: AppColors.white),
        ),
      ),
      backgroundColor: const Color(0xFF7F8488),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      elevation: 6,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
