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

  // @override
  // Widget build(BuildContext context) {
  //   final border = OutlineInputBorder(
  //     borderRadius: BorderRadius.circular(6),
  //     borderSide: const BorderSide(color: AppColors.black, width: 1)
  //   );
  //
  //   return SizedBox(
  //     width: width,
  //     height: height,
  //     child: DropdownButtonFormField<String>(
  //       value: selectedValue,
  //       onChanged: onChanged,
  //       items: items
  //           .map((item) => DropdownMenuItem(value: item, child: Text(item)))
  //           .toList(),
  //       decoration: InputDecoration(
  //         hintText: hintText ?? '선택하세요',
  //         contentPadding: const EdgeInsets.only(left: 14),
  //         border: border,
  //         focusedBorder: border
  //       ),
  //       icon: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //         child: const Icon(Icons.arrow_drop_down),
  //       ),
  //       //alignment: AlignmentDirectional.topStart,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownMenu<String>(
        width: width,
        initialSelection: selectedValue,
        onSelected: onChanged,
        dropdownMenuEntries: items
            .map((item) => DropdownMenuEntry(value: item, label: item))
            .toList(),
        hintText: hintText ?? '선택하세요',
        trailingIcon: const Icon(
          Icons.arrow_drop_down,
          size: 20, // ✅ 원하는 사이즈로 지정 (예: 24~28 추천)
        ),
        textStyle: const TextStyle(
          fontSize: 13,
          height: 1.0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          constraints: const BoxConstraints(
            minHeight: 32,
            maxHeight: 43,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
        ),
        menuStyle: MenuStyle(
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.all(Colors.white),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          maximumSize: WidgetStateProperty.all(
            Size(width, 200),
          ),
        ),
      ),
    );
  }

}