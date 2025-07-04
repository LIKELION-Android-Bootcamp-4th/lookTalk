import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/const/gap.dart';

class SignupChoiceScreen extends StatelessWidget {
  final String email;
  final String provider;

  const SignupChoiceScreen({
    required this.email,
    required this.provider,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => context.push('/home'),
            icon: Icon(Icons.home_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('어떻게 이용하실 건가요?', style: context.h1.copyWith(fontSize: 25)),
            gap16,
            Row(
              children: [
                _buildRoundedButton(context, '판매자로 시작하기', () {
                  context.push('/signup/seller?email=$email&provider=$provider&platformRole=seller');
                }),
                gapW32,
                _buildRoundedButton(context, '쇼핑하러 가기', () {
                  context.push('/signup/user?email=$email&provider=$provider&platformRole=buyer');
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoundedButton(
    BuildContext context,
    String text,
    VoidCallback onPressed,
  ) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: Size(150, 150),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      child: Text(text, style: context.h1.copyWith(fontSize: 25)),
    );
  }
}
