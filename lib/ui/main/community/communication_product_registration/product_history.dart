import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:provider/provider.dart';

import '../../../../model/entity/response/order_product_summary.dart';
import '../../../../view_model/community/selected_product_view_model.dart';
import '../../../../view_model/mypage_view_model/search_my_product_list_viewmodel.dart';
import '../../../common/const/gap.dart';

class CommunityProductHistory extends StatelessWidget {
  const CommunityProductHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchMyProductListViewmodel>();

    final productItems = viewModel.orders
        .expand((order) => order.items)
        .toList();

    if (productItems.isEmpty) {
      return const Center(child: Text("구매 내역이 없습니다."));
    }

    return _buildProductGrid(context, productItems);
  }

  Widget _buildProductGrid(BuildContext context,
      List<OrderProductSummary> items,) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        return _buildProductCard(context, items[index]);
      },
    );
  }

  Widget _buildProductCard(BuildContext context, OrderProductSummary item) {
    final imageUrl = item.thumbnailImage;
    final storeName = item.storeName;
    final productName = item.name;
    final isValidImage = imageUrl != null && imageUrl
        .trim()
        .isNotEmpty;
    final selectedProductId = context
        .watch<SelectedProductViewModel>()
        .selectedProduct
        ?.id;
    final isSelected = selectedProductId == item.id;

    return GestureDetector(
      onTap: () {
        context.read<SelectedProductViewModel>().selectFromOrderSummary(item);
      },
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 100,
            height: 103,
            child: Stack(
              alignment: Alignment.center,
              children: [
                isValidImage
                    ? Image.network(
                  imageUrl!,
                  width: 100,
                  height: 103,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 100),
                )
                    : const Icon(Icons.image, size: 100),
                if (isSelected)
                  Container(
                    width: 100,
                    height: 103,
                    color: Colors.black.withOpacity(0.5),
                  ),
                if (isSelected)
                  const Icon(Icons.check, color: Colors.white, size: 40),
              ],
            ),
          ),
        ),
        gap8,

        Text(
          storeName ?? '',
          style: context.h1.copyWith(fontSize: 12),
        ),

        gap4,

        Text(
          productName,
          style: context.bodyBold.copyWith(fontSize: 12),
        ),
      ],
    ),);
  }
}
