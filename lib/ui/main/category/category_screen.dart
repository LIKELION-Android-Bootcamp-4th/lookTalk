import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget{
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('카테고리'),),
      body: Center(child: Text('카테고리'),),
    );
  }
}