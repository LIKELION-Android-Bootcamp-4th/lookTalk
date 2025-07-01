import 'package:flutter/material.dart';

import '../const/colors.dart';

class CommonLoading extends StatelessWidget {
  const CommonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 36.0,
        height: 36.0,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary), //
        ),
      ),
    );
  }
}
