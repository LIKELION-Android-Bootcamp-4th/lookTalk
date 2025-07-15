import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/ui/product/product_detail/product_detail_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/text_sizes.dart';
import 'package:look_talk/view_model/product/product_detail_viewmodel.dart';
import 'package:look_talk/ui/product/inquiry/inquiry_screen.dart';
import '../../../view_model/product/product_post_list_viewmodel.dart';
import '../../../view_model/viewmodel_provider.dart';
import '../../../model/repository/post_repository.dart';
import '../../../model/client/post_api_client.dart';
import '../../../core/network/dio_client.dart';
import 'community_section_widget.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  Widget _buildTabContent(BuildContext context, ProductDetailViewModel vm, int index) {
    switch (index) {
      case 0:
        return const Text('상품 설명 페이지 이미지로 대체 예정');
      case 1:
        return const Text('리뷰 페이지');
      case 2:
        return Provider<PostRepository>(
          create: (_) => PostRepository(PostApiClient(DioClient.instance)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommunitySectionWidget(
                category: 'coord_question',
                title: '코디 질문',
                productId: vm.productId,
              ),
              CommunitySectionWidget(
                category: 'coord_recommend',
                title: '코디 추천',
                productId: vm.productId,
              ),
            ],
          ),
        );
      case 3:
        return InquiryScreen();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailViewModel>(builder: (context, vm, _) {
      return ChangeNotifierProvider<ProductPostListViewModel>(
        create: (_) => provideProductPostListViewModel(vm.productId),
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 1,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
            ),
            iconTheme: const IconThemeData(color: AppColors.primary),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.home_outlined)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart_outlined)),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        vm.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 16),
                      if (vm.storeName.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            '${vm.storeName} >',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          vm.productName,
                          style: const TextStyle(
                            fontSize: TextSizes.headline,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Text(
                              '${vm.discountPercent}%',
                              style: const TextStyle(
                                fontSize: TextSizes.body,
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${vm.originalPrice.toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (match) => "${match[1]},")}원',
                              style: const TextStyle(
                                fontSize: TextSizes.body,
                                color: AppColors.black,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          '${vm.finalPrice.toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (match) => "${match[1]},")}원~',
                          style: const TextStyle(
                            fontSize: TextSizes.body,
                            fontWeight: FontWeight.w700,
                            color: AppColors.red,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(vm.tabs.length, (index) {
                            final isSelected = index == vm.selectedIndex;
                            return GestureDetector(
                              onTap: () => vm.selectTab(index),
                              child: Text(
                                vm.tabs[index],
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? AppColors.black : Colors.grey,
                                  fontSize: TextSizes.body,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      const Divider(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildTabContent(context, vm, vm.selectedIndex),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            height: 60,
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFBDBDBD), width: 0.5)),
              color: AppColors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: vm.toggleWishlist,
                  child: Row(
                    children: [
                      Icon(
                        vm.isWishlist ? Icons.favorite : Icons.favorite_border,
                        color: AppColors.black,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        vm.wishlistCount.toString(),
                        style: const TextStyle(
                          fontSize: TextSizes.body,
                          color: AppColors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showOptionBottomSheet(
                        context: context,
                        options: vm.options,
                        originalPrice: vm.originalPrice,
                        discountRate: vm.discountPercent,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.btnPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '구매하기',
                      style: TextStyle(
                        fontSize: TextSizes.body,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
