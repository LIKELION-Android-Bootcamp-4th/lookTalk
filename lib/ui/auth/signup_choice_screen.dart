import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/const/gap.dart';

class SignupChoiceScreen extends StatelessWidget {

  const SignupChoiceScreen({
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
            gap64,
            gap32,
            Text('어떻게 이용하실 건가요?', style: context.h1.copyWith(fontSize: 25)),
            gap64,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRoundedButton(context, '판매자로\n시작하기', () {
                  context.push('/signup/seller');
                }),
                gapW32,
                _buildRoundedButton(context, '쇼핑하러\n가기', () {
                  context.push('/signup/user');
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
      child: Center(child: Text(text, style: context.h1.copyWith(fontSize: 25), textAlign: TextAlign.center,)),
    );
  }
}
