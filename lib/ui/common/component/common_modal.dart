import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/gap.dart';

// 사용 예시 ( ex. 모달 열기 버튼 클릭시 로그아웃 모달 표시 )
//             ElevatedButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) => CommonModal(
//                     title: '로그아웃',
//                     content: '로그아웃 하시겠습니까?',
//                     confirmText: '로그아웃',
//                     onConfirm: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 );
//               },
//               child: Text('모달 열기', style: context.body),
//             ),


class CommonModal extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;

  CommonModal({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    this.cancelText = "취소",
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: context.h1.copyWith(color: AppColors.btnPrimary)),
            gap32,
            Text(content, style: context.body),
            gap24,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.btnSecondary,
                    fixedSize: Size(110, 42),
                  ),
                  child: Text(cancelText, style: context.bodyBold),
                ),
                gapW8,
                ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.btnPrimary,
                    fixedSize: Size(110, 42),
                  ),
                  child: Text(
                    confirmText,
                    style: context.bodyBold?.copyWith(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
