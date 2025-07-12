import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget{
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('찜'),),
      body: Center(child: Text('찜한 상품 목록'),),
    );
  }
}