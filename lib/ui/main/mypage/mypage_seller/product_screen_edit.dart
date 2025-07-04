import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/model/entity/product_entity.dart';
import 'package:look_talk/view_model/product/product_edit_viewmodel.dart';
import 'package:look_talk/ui/common/component/common_text_field.dart';

class ProductEditScreen extends StatelessWidget {
  final Product product;

  const ProductEditScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductEditViewModel(product: product),
      child: const _ProductEditForm(),
    );
  }
}

class _ProductEditForm extends StatelessWidget {
  const _ProductEditForm({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductEditViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("상품 정보 수정")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(vm.product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),

            Image.asset(
              'assets/images/sample_tshirt.png',
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),

            Text('상품 번호: ${vm.product.code}'),
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
              items: ['판매중', '판매중지'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
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
                    onPressed: () {
                      // 삭제 로직
                      print("상품 삭제됨");
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
