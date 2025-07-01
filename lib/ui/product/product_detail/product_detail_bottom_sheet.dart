import 'package:flutter/material.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/text_sizes.dart';

void showOptionBottomSheet(BuildContext context) {
  List<String> colorOptions = ['검정색', '흰색']; // 예시로 옵션 넣어놨어요 추후 판매자 등록대로 수정예정!
  List<String> sizeOptions = ['S', 'M', 'L'];
  int discountedPrice = 00000;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (context) {
      String selectedColor = colorOptions[0];
      String selectedSize = sizeOptions[0];
      int quantity = 1;

      return StatefulBuilder(
        builder: (context, setState) {
          int totalPrice = discountedPrice * quantity;

          return Padding(
            padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(16)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "색상",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: TextSizes.headline,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: colorOptions.map((color) {
                    return ChoiceChip(
                      label: Text(
                        color,
                        style: TextStyle(fontSize: TextSizes.body),
                      ),
                      selected: selectedColor == color,
                      onSelected: (_) {
                        setState(() => selectedColor = color);
                      },
                      selectedColor: AppColors.secondary,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  "사이즈",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: TextSizes.headline,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: sizeOptions.map((size) {
                    return ChoiceChip(
                      label: Text(
                        size,
                        style: TextStyle(fontSize: TextSizes.body),
                      ),
                      selected: selectedSize == size,
                      onSelected: (_) {
                        setState(() => selectedSize = size);
                      },
                      selectedColor: AppColors.secondary,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() => quantity--);
                              }
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text(
                            "$quantity",
                            style: TextStyle(fontSize: TextSizes.body),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() => quantity++);
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      Text(
                        "$totalPrice 원",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: TextSizes.headline,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          // 장바구니
                        },
                        child: Text(
                          "장바구니",
                          style: TextStyle(fontSize: TextSizes.body, color: Colors.black),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // 구매하기
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.btnPrimary,
                        ),
                        child: Text(
                          "구매하기",
                          style: TextStyle(fontSize: TextSizes.body, color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      );
    },
  );
}