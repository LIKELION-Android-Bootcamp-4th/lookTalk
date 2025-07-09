// lib/ui/main/cart/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:look_talk/view_model/cart/cart_view_model.dart';
import 'package:provider/provider.dart';
import '../common/const/colors.dart';
import '../common/const/gap.dart';
import '../common/const/text_sizes.dart';
import '../common/component/primary_button.dart';
import 'order_screen.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // build가 완료된 후 fetchCart를 실행하도록 변경
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartViewModel>().fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CartViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('장바구니', style: TextStyle(fontSize: TextSizes.headline, color: AppColors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.black),
        actions: [
          TextButton(
            onPressed: viewModel.removeSelectedItems,
            child: Text('선택 삭제', style: TextStyle(color: AppColors.black, fontSize: TextSizes.body)),
          ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
      // [✅ cartItems가 비어있는지 확인하여 UI를 분기합니다]
          : viewModel.cartItems.isEmpty
      // [✅ 장바구니가 비었을 때 보여줄 UI]
          ? const Center(
        child: Text(
          '장바구니에 담긴 상품이 없습니다.',
          style: TextStyle(fontSize: TextSizes.body, color: AppColors.textGrey),
        ),
      )
      // [✅ 상품이 있을 때 보여줄 UI]
          : Column(
        children: [
          gap16,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Checkbox(
                  value: viewModel.isAllSelected,
                  onChanged: (v) => viewModel.toggleSelectAll(v ?? false),
                  activeColor: AppColors.primary,
                ),
                Text('전체 선택(${viewModel.selectedItemIds.length}/${viewModel.cartItems.length})', style: TextStyle(fontSize: TextSizes.body)),
              ],
            ),
          ),
          gap16,
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: viewModel.cartItems.length,
              itemBuilder: (context, i) {
                final item = viewModel.cartItems[i];
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: AppColors.white,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: viewModel.selectedItemIds.contains(item.id),
                          onChanged: (v) => viewModel.toggleItemSelection(item.id, v ?? false),
                          activeColor: AppColors.primary,
                        ),
                        gapW8,
                        Container(
                          width: 70,
                          height: 90,
                          decoration: BoxDecoration(
                            color: AppColors.boxGrey,
                            borderRadius: BorderRadius.circular(8),
                            image: item.product.thumbnailImage != null
                                ? DecorationImage(
                              image: NetworkImage(item.product.thumbnailImage!),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: item.product.thumbnailImage == null
                              ? Icon(Icons.image, color: AppColors.textGrey, size: 36)
                              : null,
                        ),
                        gapW16,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(item.product.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body)),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      // X 버튼 클릭 시 해당 아이템만 삭제하는 로직
                                      viewModel.toggleItemSelection(item.id, true);
                                      viewModel.removeSelectedItems();
                                    },
                                    child: Icon(Icons.close, color: AppColors.textGrey, size: 22),
                                  ),
                                ],
                              ),
                              gap4,
                              Text(item.product.name, style: TextStyle(fontSize: TextSizes.body)),
                              gap8,
                              Text(
                                '${item.product.unitPrice.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}원',
                                style: const TextStyle(
                                  fontSize: TextSizes.caption,
                                  color: AppColors.textGrey,
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              gap4,
                              Row(
                                children: [
                                  Text(
                                    '${item.totalPrice.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}원',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              gap8,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 16, color: Colors.black.withOpacity(0.04))],
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text('결제 예상 금액', style: TextStyle(fontSize: TextSizes.body)),
                    const Spacer(),
                    Text(
                      '${viewModel.totalSelectedPrice.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')} 원',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body),
                    ),
                  ],
                ),
                gap16,
                PrimaryButton(
                  text: '구매하기',
                  onPressed: viewModel.selectedItemIds.isNotEmpty
                      ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderScreen(selectedIds: viewModel.selectedItemIds.toList()),
                      ),
                    );
                  }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}