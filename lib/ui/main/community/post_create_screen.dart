import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_text.dart';
import 'package:look_talk/ui/common/component/common_dropdown.dart';
import 'package:look_talk/ui/common/component/common_snack_bar.dart';
import 'package:look_talk/ui/common/component/common_text_field.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:look_talk/view_model/community/selected_product_view_model.dart';
import 'package:provider/provider.dart';

import '../../../model/entity/post_entity.dart';
import '../../../model/entity/response/search_response.dart';
import '../../../model/entity/selected_product.dart';
import '../../../view_model/community/post_create_view_model.dart';
import '../../common/const/colors.dart';

class PostCreateScreen extends StatelessWidget {
  final List<String> category = ['코디 질문', '코디 추천'];

  PostCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedProduct = context.watch<SelectedProductViewModel>().selectedProduct;

    if (selectedProduct != null) {
      context.read<PostCreateViewModel>().setProductId(selectedProduct.id);
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          context.read<PostCreateViewModel>().clearImage();
          context.read<SelectedProductViewModel>().deselectProduct();
        }
      },
      child: Scaffold(
        appBar: _buildRegisterButton(context),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryDropdown(context),
                gap24,
                _buildTitleField(context),
                gap24,
                _buildContentField(context),
                gap24,
                _buildProductButton(context),
                gap12,
                if(selectedProduct != null) _buildSelectedProductPreview(context, selectedProduct),
                gap24,
                _buildPictureField(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildRegisterButton(BuildContext context) {
    return AppBarText(
      title: '게시글 등록',
      text: '등록',
      onPressed: () async {
        final vm = context.read<PostCreateViewModel>();

        try {
          final postId = await vm.submitPost();
          //print('게시글 프스트 아이디!!! : $postId');
          if (postId != null) {
            context.read<SelectedProductViewModel>().deselectProduct();
            context.read<PostCreateViewModel>().clearImage();
            // context.pop(true);
            //
            // context.push('/post/$postId');
            context.pop(postId);
          }else{
            //print('post id가 null 입니다.');
          }
        } catch (e) {
          //print('예외 발생!!!! $e');
          CommonSnackBar.show(context, message: '${e.toString()}');
        }
      },
    );
  }

  Widget _buildCategoryDropdown(BuildContext context) {
    final vm = context.read<PostCreateViewModel>();
    return CommonDropdown(
      items: vm.categoryMap.keys.toList(),
      onChanged: (label) {
        final value = vm.categoryMap[label];
        if (value != null) vm.setCategory(value);
      },
    );
  }

  Widget _buildTitleField(BuildContext context) {
    final vm = context.read<PostCreateViewModel>();
    return CommonTextField(hintText: '제목', onChanged: vm.setTitle,);
  }

  Widget _buildContentField(BuildContext context) {
    final vm = context.read<PostCreateViewModel>();
    return CommonTextField(hintText: '내용', maxLines: 10, onChanged: vm.setContent,);
  }

  Widget _buildProductButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/community/write/product-register');
      },
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: Colors.black, width: 1.2),
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('상품 정보 추가', style: context.bodyBold),
            Icon(Icons.chevron_right_rounded, size: 24, color: AppColors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedProductPreview(BuildContext context, SelectedProduct product) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.iconGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              product.imageUrl ?? '',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.storeName ?? '', style: const TextStyle(fontSize: 12)),
                Text(product.name ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              context.read<SelectedProductViewModel>().deselectProduct();

            },
            icon: const Icon(Icons.close),
          )
        ],
      ),
    );
  }

  Widget _buildPictureField(BuildContext context) {
    final viewModel = context.watch<PostCreateViewModel>();
    final imageFile = viewModel.imageFile;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('갤러리에서 선택'),
                  onTap: () {
                    Navigator.pop(context);
                    viewModel.pickImage();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('카메라로 촬영'),
                  onTap: () async {
                    Navigator.pop(context);
                    await viewModel.takePhoto();
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: imageFile == null
          ? Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.boxGrey,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Icon(Icons.add, size: 50, color: Color(0xFF6F6F6F)),
        ),
      )
          : Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.file(
              imageFile,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () => viewModel.clearImage(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
