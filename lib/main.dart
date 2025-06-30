import 'package:flutter/material.dart';
import 'package:look_talk/ui/common/const/text_sizes.dart';
import 'package:look_talk/ui/main/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LookTalk',
      theme: ThemeData(
        fontFamily: 'NanumSquareRound',
        textTheme: const TextTheme(
          // 제목
          headlineLarge: TextStyle(
            fontSize: TextSizes.headline,
            fontWeight: FontWeight.w800
          ),
          //


          // 일반 본문
          bodyLarge: TextStyle(
            fontSize: TextSizes.body,
            fontWeight: FontWeight.w700
          ),

          // 일반 본문
          bodyMedium: TextStyle(
            fontSize: TextSizes.body,
            fontWeight: FontWeight.w400
          ),

          // 부가 설명용
          bodySmall: TextStyle(
            fontSize: TextSizes.caption,
            fontWeight: FontWeight.w300
          )



        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true
      ),
      home: HomeScreen()
    );
  }
}

