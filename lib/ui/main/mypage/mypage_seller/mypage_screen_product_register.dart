import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/view_model/product/product_register_viewmodel.dart';
import 'package:look_talk/view_model/category/category_data_select_viewmodel.dart';
import 'package:look_talk/ui/common/component/common_text_field.dart';

import '../../../../model/entity/response/gender_category_id.dart';
import '../../../common/component/common_snack_bar.dart';

class ProductRegisterScreen extends StatelessWidget {
  const ProductRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProductRegisterForm();
  }
}

class _ProductRegisterForm extends StatelessWidget {
  const _ProductRegisterForm({super.key});

  static const sizeOptions = ['S', 'M', 'L'];
  static const colorOptions = ['흰색', '검정색', '파란색', '빨간색', '초록색'];

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductRegisterViewModel>();
    final catVm = context.watch<CategoryDataSelectViewmodel>();

    final selectedSizes = vm.selectedSizes;
    final selectedColors = vm.selectedColors;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: vm.pickImage,
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: vm.imageFile != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(vm.imageFile!.path),
                  fit: BoxFit.cover,
                ),
              )
                  : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text("사진 업로드"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: vm.pickContentImage,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: vm.contentImage != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(vm.contentImage!.path),
                  fit: BoxFit.fitHeight, // ⬅️ 세로 이미지 대비
                ),
              )
                  : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, size: 40, color: Colors.grey),
                  SizedBox(height: 8),
                  Text("설명용 이미지 업로드"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          _buildDropdown<GenderType>(
            hint: '성별',
            value: catVm.selectedGender,
            items: GenderType.values,
            itemBuilder: (e) => e.name,
            onChanged: (g) => catVm.fetchMainCategories(g!),
          ),
          const SizedBox(height: 16),

          _buildDropdown(
            hint: '상위 카테고리',
            value: catVm.selectedMainCategory?.name,
            items: catVm.categories.map((e) => e.name).toList(),
            itemBuilder: (e) => e,
            onChanged: (name) {
              final cat = catVm.categories.firstWhere((e) => e.name == name);
              catVm.selectMainCategory(cat);
            },
          ),
          const SizedBox(height: 16),

          _buildDropdown(
            hint: '하위 카테고리',
            value: catVm.selectedSubCategory?.name,
            items: catVm.subCategories.map((e) => e.name).toList(),
            itemBuilder: (e) => e,
            onChanged: (name) {
              final cat = catVm.subCategories.firstWhere((e) => e.name == name);
              catVm.changeSubCategory(cat);
            },
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
          const Text('사이즈 선택', style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: sizeOptions.map((size) {
              final isSelected = vm.selectedSizes.contains(size);
              return FilterChip(
                label: Text(size),
                selected: isSelected,
                onSelected: (_) => vm.toggleSize(size),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),
          const Text('색상 선택', style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: colorOptions.map((color) {
              final isSelected = vm.selectedColors.contains(color);
              return FilterChip(
                label: Text(color),
                selected: isSelected,
                onSelected: (_) => vm.toggleColor(color),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
          if (selectedColors.isNotEmpty && selectedSizes.isNotEmpty) ...[
            const Text('재고 수량 입력', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Column(
              children: [
                for (final color in selectedColors)
                  for (final size in selectedSizes)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: CommonTextField(
                        hintText: '$color - $size 재고',
                        keyboardType: TextInputType.number,
                        controller: vm.getStockController('${color}_$size'),
                      ),
                    ),
              ],
            ),
          ],

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: vm.isLoading
                  ? null
                  : () async {
                final success = await vm.registerAndNotify(context);
                if (!context.mounted) return;

                if (success) {
                  DefaultTabController.of(context)?.animateTo(0);
                  CommonSnackBar.show(context, message: '상품이 성공적으로 등록되었습니다.');
                } else {
                  CommonSnackBar.show(context, message: '상품 등록에 실패했습니다. 입력 값을 확인해주세요.');
                }
              },
              child: vm.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('완료'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required String Function(T) itemBuilder,
    ValueChanged<T?>? onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: hint,
        border: const OutlineInputBorder(),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(itemBuilder(e))))
          .toList(),
      onChanged: onChanged,
    );
  }
}
