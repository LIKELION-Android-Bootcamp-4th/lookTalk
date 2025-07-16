import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/model/entity/product_entity.dart';
import 'package:look_talk/view_model/product/product_edit_viewmodel.dart';
import 'package:look_talk/view_model/product/product_viewmodel.dart';
import 'package:look_talk/model/repository/product_repository.dart';
import 'package:look_talk/ui/common/component/common_text_field.dart';
import 'package:look_talk/core/network/dio_client.dart';

class ProductEditScreen extends StatelessWidget {
  final ProductEntity product;
  final ProductViewModel productViewModel;

  const ProductEditScreen({
    super.key,
    required this.product,
    required this.productViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductEditViewModel(
        product: product,
        repository: ProductRepository(DioClient.instance),
      ),
      child: _ProductEditForm(productViewModel: productViewModel),
    );
  }
}

class _ProductEditForm extends StatelessWidget {
  final ProductViewModel productViewModel;

  const _ProductEditForm({super.key, required this.productViewModel});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductEditViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("상품 정보 수정")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vm.product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),

            // 썸네일 이미지 미리보기 및 변경 버튼
            const Text('썸네일 이미지', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            vm.thumbnailImageFile != null
                ? Image.file(vm.thumbnailImageFile!, width: 180, height: 180, fit: BoxFit.cover)
                : (vm.product.thumbnailUrl != null && vm.product.thumbnailUrl!.isNotEmpty
                ? Image.network(
              vm.product.thumbnailUrl!,
              width: 180,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, size: 80),
            )
                : const Icon(Icons.image_not_supported, size: 80)),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: vm.pickThumbnailImage,
              icon: const Icon(Icons.image),
              label: const Text('이미지 변경'),
            ),

            const SizedBox(height: 24),
            Text('상품 번호: ${vm.product.productId}'),
            const SizedBox(height: 16),

            const Text('재고', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            CommonTextField(
              controller: vm.stockController,
              hintText: '재고 수량',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            const Text('판매 상태', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: vm.status,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: ['판매중', '판매중지']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: vm.setStatus,
            ),
            const SizedBox(height: 12),

            const Text('정가', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            CommonTextField(
              controller: vm.priceController,
              hintText: '상품 정가',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            const Text('할인율 (%)', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            CommonTextField(
              controller: vm.discountController,
              hintText: '할인율 입력',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final success = await vm.deleteProduct(context);
                      if (success) {
                        productViewModel.fetchProducts();
                        if (context.mounted) Navigator.pop(context, true);
                      }
                    },
                    child: const Text("상품 삭제하기"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => vm.submit(context),
                    child: const Text("완료"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
