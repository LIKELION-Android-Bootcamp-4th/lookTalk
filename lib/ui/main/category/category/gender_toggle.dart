import 'package:flutter/material.dart';

class GenderToggle extends StatelessWidget{
  final String selectedGender;
  final Function(String) onSelectedButton;

  const GenderToggle({required this.selectedGender, required this.onSelectedButton});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: GestureDetector(
          onTap: () => onSelectedButton('남자'),
          child: Container(
            width: 131,
            height: 29,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selectedGender == '남자' ? Colors.lightBlueAccent : Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text("남자",
              style: TextStyle(
                color: selectedGender == '남자' ? Colors.black : Colors.grey[500],
              ),
            ),

          ),
        ),
        ),
        Expanded(child: GestureDetector(
          onTap: () => onSelectedButton('여자'),
          child: Container(
            width: 131,
            height: 29,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selectedGender == '여자' ? Colors.lightBlueAccent: Colors.white,
              borderRadius: BorderRadius.circular(14),

            ),
            child: Text("여자",
    style: TextStyle(
    color: selectedGender == '여자' ? Colors.black : Colors.grey[500],
    ),),
          ),
        ))
      ],
    );
  }
}