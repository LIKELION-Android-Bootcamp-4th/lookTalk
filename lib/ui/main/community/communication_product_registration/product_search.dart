import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/community/selected_product_view_model.dart';
import '../../../../view_model/search_view_model.dart';
import '../../../common/const/gap.dart';

class CommunityProductSearch extends StatefulWidget {
  const CommunityProductSearch({super.key});

  @override
  State<CommunityProductSearch> createState() => _CommunityProductSearchState();
}

class _CommunityProductSearchState extends State<CommunityProductSearch> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose(); // 메모리 누수 방지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchViewModel>();

    return Column(
      children: [
        _buildSearchInput(context),
        _buildProductGrid(context, viewModel),
      ],
    );
  }

  Widget _buildSearchInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _controller,
        onSubmitted: (value) {
          context.read<SearchViewModel>().search(value);
        },
        decoration: InputDecoration(
          hintText: '상품명을 입력하세요',
          suffixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context.read<SearchViewModel>().search(_controller.text);
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context, SearchViewModel viewModel) {
    if (viewModel.products.isEmpty) {
      return const Expanded(child: Center(child: Text('검색 결과가 없습니다.')));
    }

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: viewModel.products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.6,
        ),
        itemBuilder: (context, index) {
          final product = viewModel.products[index];
          return _buildProductCard(context, product);
        },
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, product) {
    final imageUrl = product.thumbnailImage;
    final isValidImage = imageUrl != null && imageUrl.trim().isNotEmpty;

    final selectedProductId = context
        .watch<SelectedProductViewModel>()
        .selectedProduct
        ?.id;
    final isSelected = selectedProductId == product.id;

    print(
      'selectedProduct.id: ${context.watch<SelectedProductViewModel>().selectedProduct?.id}',
    );
    print('product.id: ${product.id}');

    return GestureDetector(
      onTap: () {
        context.read<SelectedProductViewModel>().selectProduct(product);
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
            product.storeName ?? '',
            style: context.h1.copyWith(fontSize: 12),
          ),
          gap4,
          Text(product.name, style: context.bodyBold.copyWith(fontSize: 10)),
          //const SizedBox(height: 4),
          //Text('${product.price}원', style: context.h1.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}
