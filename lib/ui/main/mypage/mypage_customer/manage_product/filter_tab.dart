import 'package:flutter/material.dart';
import 'package:look_talk/ui/common/component/common_dropdown.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/gap.dart';

class FilterTab extends StatefulWidget {
  const FilterTab({super.key});

  @override
  State<StatefulWidget> createState() => _FilterTabState();
}

class _FilterTabState extends State<FilterTab>{
  final List<String> options = ['1개월','3개월','6개월']; //현재 하드 코딩, 나중에 state빼기
  String selected = '3개월';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [

            CommonDropdown(
              items: options,
              width: 106,
              height: 40,
              selectedValue: selected,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selected = value;
                  });
                }
              },
            ),
            gapW8,
            Expanded(
              child: Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textGrey),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '2025.03.29 ~ 2025.06.29',
                  style: TextStyle(color: AppColors.textGrey),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
            gapW8,
            // 조회 버튼 - 고정 크기
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.textGrey,
                foregroundColor: AppColors.black,
                minimumSize: Size(60, 40),
              ),
              onPressed: () {},
              child: const Text('조회'),
            ),

          ],
        )

      ],
    );
  }
}