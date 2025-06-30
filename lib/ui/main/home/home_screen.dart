import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '헤드라인 텍스트입니다',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text('본문 텍스트입니다', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Text('설명 텍스트입니다', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
