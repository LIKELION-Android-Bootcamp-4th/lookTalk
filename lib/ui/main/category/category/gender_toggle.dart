import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/response/gender_category_id.dart';

class GenderToggle extends StatelessWidget{
  final GenderType selectedGender;
  final Function(GenderType) onSelectedButton;

  const GenderToggle({required this.selectedGender, required this.onSelectedButton});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: GestureDetector(
          onTap: () => onSelectedButton(GenderType.male),
          child: Container(
            width: 131,
            height: 29,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selectedGender == GenderType.male ? Colors.lightBlueAccent : Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text("남자",
              style: TextStyle(
                color: selectedGender == GenderType.male ? Colors.black : Colors.grey[500],
              ),
            ),

          ),
        ),
        ),
        Expanded(child: GestureDetector(
          onTap: () => onSelectedButton(GenderType.female),
          child: Container(
            width: 131,
            height: 29,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selectedGender == GenderType.female ? Colors.lightBlueAccent: Colors.white,
              borderRadius: BorderRadius.circular(14),

            ),
            child: Text("여자",
    style: TextStyle(
    color: selectedGender == GenderType.female ? Colors.black : Colors.grey[500],
    ),),
          ),
        ))
      ],
    );
  }
}