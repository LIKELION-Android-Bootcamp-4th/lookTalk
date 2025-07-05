import 'package:flutter/material.dart';

import '../const/colors.dart';

// 사용 예시
// CommonDropdown(
//               items: example,
//               selectedValue: selectedItem,
//               hintText: '조회 기간',
//               onChanged: (value) {
//                 setState(() {
//                   selectedItem = value;
//                 });
//               },
//             ),

// 이 위젯은 스타일 및 렌더링만 담당해서
// 선택된 값(state)은 화면의 별도 상태 모델에서 관리해주시면 됩니다!

class CommonDropdown extends StatelessWidget {
  final List<String> items;
  final String? selectedValue;
  final void Function(String?) onChanged;
  final String? hintText;
  final double width;
  final double height;

  const CommonDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.selectedValue,
    this.hintText,
    this.width = 150,
    this.height = 35,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: AppColors.black, width: 1)
    );

    return SizedBox(
      width: width,
      height: height,
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        onChanged: onChanged,
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        decoration: InputDecoration(
          hintText: hintText ?? '선택하세요',
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          border: border,
          focusedBorder: border
        ),
        icon: const Icon(Icons.arrow_drop_down),
      ),
    );
  }
}