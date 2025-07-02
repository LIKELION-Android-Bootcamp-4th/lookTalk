import 'package:flutter/material.dart';

// 사용 예시
// 아래와 같이 사용하면 기본 값으로 되고 hintText, 높이, 너비 등 추가 설정 가능합니다!
// CommonTextField()

// 높이는 maxLines 로 조정하시면 됩니다!

class CommonTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final int? maxLines;
  final FormFieldValidator<String>? validator;
  final EdgeInsetsGeometry contentPadding;
  final FocusNode? focusNode;
  final double? width;

  const CommonTextField({
    super.key,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines,
    this.validator,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    this.focusNode,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        focusNode: focusNode,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: contentPadding,
          filled: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}