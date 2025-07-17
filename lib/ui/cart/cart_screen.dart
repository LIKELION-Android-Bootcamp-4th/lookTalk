// lib/ui/cart/cart_screen.dart

import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/response/product_response.dart'; // [수정] product_response import
import 'package:look_talk/view_model/cart/cart_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:look_talk/model/entity/response/cart_response.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: viewModel.cartItems.length,
              itemBuilder: (context, i) {
                final item = viewModel.cartItems[i];
                // [수정] discountInfo 변수는 그대로 사용합니다.
                final discountInfo = item.product.discount;

                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey[200]!, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  color: AppColors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: viewModel.selectedItemIds.contains(item.id),
                          onChanged: (v) => viewModel.toggleItemSelection(item.id!, v ?? false),
                          activeColor: AppColors.primary,
                        ),
                        gapW8,
                        Container(
                          width: 60,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.boxGrey,
                            borderRadius: BorderRadius.circular(8),
                            // [수정] thumbnailImageUrl을 사용하고, null일 경우를 대비합니다.
                            image: item.product.thumbnailImageUrl != null
                                ? DecorationImage(
                              image: NetworkImage(item.product.thumbnailImageUrl!),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          // [수정] thumbnailImageUrl이 null일 때 아이콘을 표시합니다.
                          child: item.product.thumbnailImageUrl == null
                              ? Icon(Icons.image_not_supported_outlined, color: AppColors.textGrey, size: 30)
                              : null,
                        ),
                        gapW12,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // [수정] store의 name을 사용하고, null일 경우를 대비합니다.
                                  Text(item.storeName ?? '스토어 없음', style: TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body)),
                                  InkWell(
                                    onTap: () {
                                      if (item.id != null) {
                                        viewModel.toggleItemSelection(item.id!, true);
                                      }
                                      viewModel.removeSelectedItems();
                                    },
                                    child: Icon(Icons.close, color: AppColors.textGrey, size: 20),
                                  ),
                                ],
                              ),
                              gap4,
                              Text(item.product.name, style: TextStyle(fontSize: TextSizes.body), maxLines: 1, overflow: TextOverflow.ellipsis,),
                              gap4,
                              // [수정] _buildPriceWidget에 product 객체와 최종 가격을 함께 전달합니다.
                              _buildPriceWidget(item.product, item.totalPrice),
                              gap4,
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.boxGrey,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                // [수정] options는 List이므로, 여기서는 수량만 표시하도록 단순화합니다.
                                // 옵션을 표시하려면 별도의 로직이 필요합니다.
                                child: Text(
                                    '수량 ${item.quantity}개',
                                    style: TextStyle(fontSize: TextSizes.caption, color: Colors.grey[600])
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
                    final productsToOrder = viewModel.cartItems
                        .where((item) => viewModel.selectedItemIds.contains(item.id))
                        .toList();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderScreen(productsToOrder: productsToOrder),
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

  // [수정] Price 위젯의 로직을 새로운 데이터 모델에 맞게 변경합니다.
  Widget _buildPriceWidget(Product product, int finalPrice) {
    final discountInfo = product.discount;

    // 할인이 없거나, 할인율이 0이면 최종 가격만 표시합니다.
    if (discountInfo == null || discountInfo.value == 0) {
      return Text(
        '${numberFormat.format(finalPrice)}원',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body),
      );
    }
    else {
      final discountPercent = discountInfo.value;
      final originalPrice = (finalPrice / (1 - (discountPercent / 100))).round();

      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 할인율
          Text(
            '$discountPercent%',
            style: const TextStyle(
              color: AppColors.red,
              fontWeight: FontWeight.bold,
              fontSize: TextSizes.body,
            ),
          ),
          gapW8,
          // 최종 가격
          Text(
            '${numberFormat.format(finalPrice)}원',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: TextSizes.body,
              color: AppColors.black,
            ),
          ),
          gapW8,
          // 원래 가격 (줄 그은 회색)
          Text(
            '${numberFormat.format(originalPrice)}원',
            style: const TextStyle(
              fontSize: TextSizes.caption,
              color: AppColors.textGrey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      );
      // // 할인 적용 시, 원가 계산 (할인율이 0이 아닐 때만)
      // final originalPrice = (finalPrice / (1 - (discountInfo.value / 100))).round();
      //
      // return Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Text(
      //       '${numberFormat.format(originalPrice)}원',
      //       style: const TextStyle(
      //         fontSize: TextSizes.caption,
      //         color: AppColors.textGrey,
      //         decoration: TextDecoration.lineThrough,
      //       ),
      //     ),
      //     // gap4,  // 간격이 너무 넓어 보일 수 있어 조절
      //     Row(
      //       children: [
      //         Text('${discountInfo.value}%', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: TextSizes.body)),
      //         gapW8,
      //         Text(
      //           '${numberFormat.format(finalPrice)}원',
      //           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body),
      //         ),
      //       ],
      //     ),
      //   ],
      // );
    }
  }
}