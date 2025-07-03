import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_search_cart.dart';

class MyPageScreen extends StatelessWidget{
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('마이페이지'),),
      body: Center(child: Text('마이페이지'),),
    );
  }
}