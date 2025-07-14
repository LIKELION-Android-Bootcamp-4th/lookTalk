import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/mypage_view_model/search_my_product_list_viewmodel.dart';

class CommunityProductHistory extends StatelessWidget{
  const CommunityProductHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchMyProductListViewmodel>(
      builder: (context, viewModel, _) {
        final productItems = viewModel.orders
            .expand((order) => order.items)
            .toList();

        if (productItems.isEmpty) {
          return const Center(child: Text("구매 내역이 없습니다."));
        }

        return _buildProductGrid(context, productItems);
      },
    );
  }

  Widget _buildProductGrid(BuildContext context, List<dynamic> items) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        return _buildProductItem(context, items[index]);
      },
    );
  }

  Widget _buildProductItem(BuildContext context, dynamic item) {
    final product = item.product;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductImage(product.thumbnailImageUrl),
        const SizedBox(height: 8),
        _buildProductPrice(context, product.price),
        _buildStoreName(context, product.storeName),
      ],
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl ?? '',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              Container(color: Colors.grey.shade200),
        ),
      ),
    );
  }

  Widget _buildProductPrice(BuildContext context, int price) {
    return Text(
      '${price.toString()}원',
      style: context.bodyBold.copyWith(fontSize: 16),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStoreName(BuildContext context, String? storeName) {
    return Text(
      storeName ?? '',
      style: context.body.copyWith(
        color: Colors.grey[600],
        fontSize: 14,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }


}