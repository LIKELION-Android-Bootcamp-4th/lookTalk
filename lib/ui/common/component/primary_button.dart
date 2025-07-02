import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/const/colors.dart';


// 사용 예시
// 아래와 같이 작성하면 기본 값으로 되고 ui에 따라 배경색, 글자색, 글자 두께, 버튼 크기 조정하시면 됩니다!!
// PrimaryButton(text: '확인', onPressed: () {}),

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double minWidth;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadiusGeometry borderRadius;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 48,
    this.minWidth = double.infinity,
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: height,
        minWidth: minWidth,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.btnPrimary,
          foregroundColor: foregroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
        child: Text(
          text,
          style: textStyle ?? context.h1?.copyWith(color: AppColors.white)
        ),
      ),
    );
  }
}