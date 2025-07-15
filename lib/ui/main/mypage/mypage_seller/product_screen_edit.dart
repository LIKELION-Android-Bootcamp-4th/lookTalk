import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/model/entity/product_entity.dart';
import 'package:look_talk/view_model/product/product_edit_viewmodel.dart';
import 'package:look_talk/view_model/product/product_viewmodel.dart';
import 'package:look_talk/model/repository/product_repository.dart';
import 'package:look_talk/ui/common/component/common_text_field.dart';
import 'package:dio/dio.dart';
import 'package:look_talk/core/network/dio_client.dart';
import 'package:look_talk/model/entity/response/product_response.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              vm.product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),

            vm.product.thumbnailUrl != null && vm.product.thumbnailUrl!.isNotEmpty
                ? Image.network(
              vm.product.thumbnailUrl!,
              width: 180,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, size: 80),
            )
                : const Icon(Icons.image_not_supported, size: 80),
            const SizedBox(height: 16),

            Text('상품 번호: ${vm.product.productId}'),
            const SizedBox(height: 16),

            CommonTextField(
              controller: vm.stockController,
              hintText: '재고',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: vm.status,
              decoration: const InputDecoration(labelText: '판매상태', border: OutlineInputBorder()),
              items: ['판매중', '판매중지']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: vm.setStatus,
            ),
            const SizedBox(height: 8),

            CommonTextField(
              controller: vm.priceController,
              hintText: '정가',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),

            CommonTextField(
              controller: vm.discountController,
              hintText: '할인율',
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
                        productViewModel.fetchProducts(); // ✅ 삭제 후 목록 최신화
                        if (context.mounted) Navigator.pop(context, true); // ✅ 결과 전달
                      }
                    },
                    child: const Text("상품 삭제하기"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: vm.submit,
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
