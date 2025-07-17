import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/view_model/product/product_detail_bottom_sheet_viewmodel.dart';
import 'package:look_talk/view_model/cart/cart_view_model.dart';
import 'package:look_talk/view_model/order/order_view_model.dart';
import 'package:look_talk/ui/common/component/primary_button.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/text_sizes.dart';
import 'package:look_talk/ui/cart/order_screen.dart';
import 'package:look_talk/model/entity/response/cart_response.dart';
import 'package:look_talk/model/entity/product_entity.dart' as entity;
import 'package:look_talk/model/entity/response/product_response.dart';

import '../../common/component/common_snack_bar.dart';

class ProductDetailBottomSheet extends StatelessWidget {
  final String productId;
  final entity.ProductEntity product;
  final int discountRate;


  const ProductDetailBottomSheet({
    super.key,
    required this.productId,
    required this.product,
    required this.discountRate,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OptionSelectionViewModel>();
    final cartVM = context.read<CartViewModel>();
    final orderVM = context.read<OrderViewModel>();

    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(20)
      ),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets.add(const EdgeInsets.symmetric(vertical: 20, horizontal: 25)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gap8,
            Text("색상", style: TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.headline)),

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
            gap24,
            Text("사이즈", style: TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.headline)),

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
            gap16,
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 27, left: 14),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
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
                    "${formatPrice(vm.totalPrice)} 원",
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
                        CommonSnackBar.show(context, message: '색상과 사이즈를 선택해주세요.');
                        return;
                      }

                      final success = await cartVM.addCartItem(
                        productId: productId,
                        unitPrice: vm.discountedPrice,
                        quantity: vm.quantity,
                        color: vm.selectedColor!,
                        size: vm.selectedSize!,
                        discountPercent: discountRate > 0 ? discountRate : null,
                      );

                      if (success) {
                        Navigator.pop(context);
                        CommonSnackBar.show(context, message: '장바구니에 담았습니다.');
                      } else {
                        CommonSnackBar.show(context, message: '장바구니에 담기 실패했습니다.');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.black),
                      minimumSize: Size(100, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("장바구니", style: context.h1.copyWith(fontSize: 17)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: PrimaryButton(
                    borderRadius: BorderRadius.circular(12),
                    text: "구매하기",
                    onPressed: () {
                      if (vm.selectedColor == null || vm.selectedSize == null) {
                        CommonSnackBar.show(context, message: '색상과 사이즈를 선택해주세요');
                        return;
                      }

                      final cartItem = CartItem(
                        product: Product.fromEntity(product),
                        quantity: vm.quantity,
                        cartPrice: vm.discountedPrice,
                        totalPrice: vm.discountedPrice * vm.quantity,
                        selectedOptions: {
                          'size': vm.selectedSize!,
                          'color': vm.selectedColor!,
                        },
                        storeName: product.storeName
                      );

                      Navigator.pop(context); // 바텀시트 닫기
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderScreen(productsToOrder: [cartItem]),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
  String formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
    );
  }
}
