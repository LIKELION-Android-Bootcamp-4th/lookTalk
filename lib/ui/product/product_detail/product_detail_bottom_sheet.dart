import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/text_sizes.dart';
import 'package:look_talk/view_model/product/product_detail_bottom_sheet_viewmodel.dart';
import 'package:look_talk/ui/common/component/primary_button.dart';

void showOptionBottomSheet(BuildContext context) {
  final viewModel = OptionSelectionViewModel();

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return ChangeNotifierProvider<OptionSelectionViewModel>.value(
        value: viewModel,
        child: Consumer<OptionSelectionViewModel>(
          builder: (context, vm, _) {
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
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: vm.colorOptions.map((color) {
                      return ChoiceChip(
                        label: Text(
                          color,
                          style: TextStyle(fontSize: TextSizes.body),
                        ),
                        selected: vm.selectedColor == color,
                        onSelected: (_) => vm.selectColor(color),
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
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: vm.sizeOptions.map((size) {
                      return ChoiceChip(
                        label: Text(
                          size,
                          style: TextStyle(fontSize: TextSizes.body),
                        ),
                        selected: vm.selectedSize == size,
                        onSelected: (_) => vm.selectSize(size),
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
                              onPressed: vm.decreaseQuantity,
                              icon: const Icon(Icons.remove),
                            ),
                            Text(
                              "${vm.quantity}",
                              style: TextStyle(fontSize: TextSizes.body),
                            ),
                            IconButton(
                              onPressed: vm.increaseQuantity,
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                        Text(
                          "${vm.totalPrice} 원",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: TextSizes.headline,
                            color: AppColors.black,
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
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.black),
                          ),
                          child: Text(
                            "장바구니",
                            style: TextStyle(fontSize: TextSizes.body, color: AppColors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: PrimaryButton(
                          text: "구매하기",
                          onPressed: () {
                            // 구매하기
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
