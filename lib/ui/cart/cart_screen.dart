// lib/ui/main/cart/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:look_talk/view_model/cart/cart_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // [✅ 숫자 포맷팅을 위해 import]
import 'package:look_talk/model/entity/response/cart_response.dart'; // [✅ Discount 클래스를 위해 import]

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
  // 숫자를 콤마(,) 포맷으로 변경해주는 Formatter
  final numberFormat = NumberFormat('###,###,###,###');

  @override
  void initState() {
    super.initState();
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
          : viewModel.cartItems.isEmpty
          ? const Center(
        child: Text(
          '장바구니에 담긴 상품이 없습니다.',
          style: TextStyle(fontSize: TextSizes.body, color: AppColors.textGrey),
        ),
      )
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
                final discountInfo = item.product.discount;

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
                                  Text(item.companyName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body)),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
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
                              _buildPriceWidget(discountInfo, item.totalPrice),
                              gap8,
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.boxGrey,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                    '옵션  ${item.product.options['color'] ?? 'N/A'} / ${item.quantity}개',
                                    style: TextStyle(fontSize: TextSizes.caption)
                                ),
                              ),
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
          // 결제 정보 및 구매하기 버튼
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
                      '${numberFormat.format(viewModel.totalSelectedPrice)} 원',
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

  Widget _buildPriceWidget(Discount? discountInfo, int finalPrice) {
    if (discountInfo == null) {
      return Text(
        '${numberFormat.format(finalPrice)}원',
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    }
    else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${numberFormat.format(discountInfo.originalPrice)}원',
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
              if (discountInfo.amount > 0)
                Text('${discountInfo.amount}%', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              gapW8,
              Text(
                '${numberFormat.format(discountInfo.discountedPrice)}원',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      );
    }
  }
}
