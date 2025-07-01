import 'package:flutter/material.dart';

import '../../ui/common/const/colors.dart';
import '../../ui/common/const/text_sizes.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      fontFamily: 'NanumSquareRound',
      textTheme: const TextTheme(

        headlineLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800, // extra bold
        ),

        bodyLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700, // bold
        ),

        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400, // regular
        ),

        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w300, // light
        ),

      ),
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      useMaterial3: true,
    );
  }
}