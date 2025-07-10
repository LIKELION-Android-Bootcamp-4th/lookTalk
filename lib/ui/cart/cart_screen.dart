// lib/ui/main/cart/cart_screen.dart

import 'package:flutter/material.dart';
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
                          onChanged: (v) => viewModel.toggleItemSelection(item.id, v ?? false),
                          activeColor: AppColors.primary,
                        ),
                        gapW8,
                        Container(
                          width: 60,
                          height: 80,
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
                                  Text(item.companyName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body)),
                                  InkWell(
                                    onTap: () {
                                      viewModel.toggleItemSelection(item.id, true);
                                      viewModel.removeSelectedItems();
                                    },
                                    child: Icon(Icons.close, color: AppColors.textGrey, size: 20),
                                  ),
                                ],
                              ),
                              gap4,
                              Text(item.product.name, style: TextStyle(fontSize: TextSizes.body), maxLines: 1, overflow: TextOverflow.ellipsis,),
                              gap4,
                              _buildPriceWidget(discountInfo, item.totalPrice),
                              gap4,
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.boxGrey,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                    '옵션  ${item.product.options['color'] ?? 'N/A'} / ${item.quantity}개',
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
                    // [✅ 선택된 상품 목록을 여기서 필터링]
                    final productsToOrder = viewModel.cartItems
                        .where((item) => viewModel.selectedItemIds.contains(item.id))
                        .toList();

                    // [✅ 필터링된 목록을 OrderScreen에 직접 전달]
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
            ),
          ),
          gap4,
          Row(
            children: [
              if (discountInfo.amount > 0)
                Text('${discountInfo.amount}%', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: TextSizes.body)),
              gapW8,
              Text(
                '${numberFormat.format(discountInfo.discountedPrice)}원',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body),
              ),
            ],
          ),
        ],
      );
    }
  }
}