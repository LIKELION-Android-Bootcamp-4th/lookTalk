import 'package:flutter/material.dart';
import 'package:look_talk/ui/common/common_modal.dart';

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
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CommonModal(
                    title: '로그아웃',
                    content: '로그아웃 하시겠습니까?',
                    confirmText: '로그아웃 하기',
                    onConfirm: () {
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
              child: Text('모달 열기'),
            ),
          ],
        ),
      ),
    );
  }
}
