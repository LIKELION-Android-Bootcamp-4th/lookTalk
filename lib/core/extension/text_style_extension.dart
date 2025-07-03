import 'package:flutter/material.dart';

// text style 지정할 때
// 원래 Theme.of(context).textTheme.bodySmall 이렇게 해서 font를 사용해야하는데
// extension 을 사용하면 context.caption 이렇게 간단하게 사용 가능합니다!!!

// 사용 예시
// Text('예시', style: context.caption)

extension TextStyleExtension on BuildContext {
  TextStyle get h1 => Theme.of(this).textTheme.headlineLarge!; // 20, extra bold
  TextStyle get body => Theme.of(this).textTheme.bodyMedium!; // 15, regular
  TextStyle get bodyBold => Theme.of(this).textTheme.bodyLarge!; // 15, bold
  TextStyle get caption => Theme.of(this).textTheme.bodySmall!; // 13, light
}
