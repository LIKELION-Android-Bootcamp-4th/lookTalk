import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/view_model/product/product_register_viewmodel.dart';
import 'package:look_talk/view_model/product/product_list_viewmodel.dart';
import 'package:look_talk/ui/common/component/common_text_field.dart';

class ProductRegisterScreen extends StatelessWidget {
  const ProductRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProductRegisterForm();
  }
}

class _ProductRegisterForm extends StatelessWidget {
  const _ProductRegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductRegisterViewModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            color: Colors.grey[300],
            child: const Center(child: Text("사진 업로드")),
          ),
          const SizedBox(height: 16),

          // 성별 Dropdown
          _buildDropdown(
            hint: '성별',
            value: vm.selectedGender,
            items: ['남성', '여성'],
            onChanged: vm.setGender,
          ),
          const SizedBox(height: 16),

          // 상위 카테고리 Dropdown (성별 선택 후에만 활성화)
          _buildDropdown(
            hint: '상위 카테고리',
            value: vm.selectedTopCategoryEntity?.mainCategory,
            items: vm.topCategoryNames,
            onChanged: vm.selectedGender == null ? null : vm.setTopCategory,
          ),
          const SizedBox(height: 16),
          // 하위 카테고리 Dropdown (상위 카테고리 선택 후 활성화)
          _buildDropdown(
            hint: '하위 카테고리',
            value: vm.selectedSubCategory,
            items: vm.subCategoryNames,
            onChanged: vm.selectedTopCategoryEntity == null ? null : vm.setSubCategory,
          ),
          const SizedBox(height: 16),

          CommonTextField(
            controller: vm.nameController,
            hintText: '상품명',
            maxLines: 1,
          ),
          const SizedBox(height: 16),

          CommonTextField(
            controller: vm.descController,
            hintText: '상품 설명',
            maxLines: 4,
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: CommonTextField(
                  controller: vm.priceController,
                  hintText: '가격',
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CommonTextField(
                  controller: vm.discountController,
                  hintText: '할인율',
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                vm.registerAndNotify(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('상품이 등록되었습니다.')),
                );
              },
              child: const Text('완료'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    ValueChanged<String?>? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: hint,
        border: const OutlineInputBorder(),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      disabledHint: value != null ? Text(value) : null,
    );
  }
}
