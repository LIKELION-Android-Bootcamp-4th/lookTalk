import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/view_model/product/product_detail_bottom_sheet_viewmodel.dart';
import 'package:look_talk/view_model/cart/cart_view_model.dart';
import 'package:look_talk/ui/common/component/primary_button.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/text_sizes.dart';

class ProductDetailBottomSheet extends StatelessWidget {
  final String productId;

  const ProductDetailBottomSheet({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OptionSelectionViewModel>();
    final cartVM = context.read<CartViewModel>();

    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.all(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("색상", style: TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.headline)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: vm.colorOptions.map((color) {
              return ChoiceChip(
                label: Text(color, style: TextStyle(fontSize: TextSizes.body)),
                selected: vm.selectedColor == color,
                onSelected: (_) => vm.selectColor(color),
                selectedColor: AppColors.secondary,
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text("사이즈", style: TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.headline)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: vm.sizeOptions.map((size) {
              return ChoiceChip(
                label: Text(size, style: TextStyle(fontSize: TextSizes.body)),
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
                    IconButton(onPressed: vm.decreaseQuantity, icon: const Icon(Icons.remove)),
                    Text("${vm.quantity}", style: TextStyle(fontSize: TextSizes.body)),
                    IconButton(onPressed: vm.increaseQuantity, icon: const Icon(Icons.add)),
                  ],
                ),
                Text(
                  "${vm.totalPrice} 원",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.headline),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    if (vm.selectedColor == null || vm.selectedSize == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('색상과 사이즈를 선택해주세요.')),
                      );
                      return;
                    }

                    final payload = {
                      'productId': productId,
                      'color': vm.selectedColor,
                      'size': vm.selectedSize,
                      'quantity': vm.quantity,
                    };

                    final result = await cartVM.addCartItem(
                      productId: productId,
                      color: vm.selectedColor!,
                      size: vm.selectedSize!,
                      quantity: vm.quantity,
                      unitPrice: vm.discountedPrice,
                    );

                    if (result.success) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('장바구니에 담았습니다.')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('실패: ${result.message ?? '오류 발생'}')),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.black),
                  ),
                  child: const Text("장바구니", style: TextStyle(fontSize: TextSizes.body, color: AppColors.black)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PrimaryButton(
                  text: "구매하기",
                  onPressed: () {
                    // 구매 처리 예정
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
  }
}
