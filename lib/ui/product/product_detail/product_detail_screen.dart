
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_home_search_cart.dart';
import 'package:look_talk/ui/common/component/common_loading.dart';
import 'package:look_talk/ui/product/product_detail/product_detail_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/text_sizes.dart';
import 'package:look_talk/view_model/product/product_detail_viewmodel.dart';
import 'package:look_talk/ui/product/inquiry/inquiry_screen.dart';
import '../../../core/utils/auth_guard.dart';
import '../../../view_model/product/product_detail_bottom_sheet_viewmodel.dart';
import '../../../view_model/product/product_post_list_viewmodel.dart';
import '../../../view_model/viewmodel_provider.dart';
import '../../../model/repository/post_repository.dart';
import '../../../model/client/post_api_client.dart';
import '../../../core/network/dio_client.dart';
import '../../common/const/gap.dart';
import 'community_section_widget.dart';
import '../../../view_model/cart/cart_view_model.dart';
import '../../../view_model/wishlist/wishlist_view_model.dart';
import 'package:look_talk/ui/product/product_detail//product_detail_review_tab.dart';
import '../../../model/entity/response/product_response.dart' as response;
import '../../../model/entity/product_entity.dart' as entity;
import 'package:look_talk/view_model/product/review_viewmodel.dart';


class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _hasLoadedWishlist = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoadedWishlist) {
      final vm = context.read<ProductDetailViewModel>();
      final wishlistVm = context.read<WishlistViewModel>();
      wishlistVm.fetchWishlistStatus(vm.productId);
      _hasLoadedWishlist = true;
    }
  }

  Widget _buildTabContent(BuildContext context, ProductDetailViewModel vm, int index) {
    switch (index) {
      case 0:
        final detailImageUrl = vm.product?.detailImageUrl;

        if (detailImageUrl == null || detailImageUrl.isEmpty) {
          return const Center(child: Text('상품 설명 이미지를 불러올 수 없습니다.'));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Image.network(
            detailImageUrl,
            width: double.infinity,
            fit: BoxFit.fitWidth,
            errorBuilder: (context, error, stackTrace) => const Text('이미지를 불러올 수 없습니다.'),
          ),
        );
      case 1:
        return ChangeNotifierProvider<ReviewViewModel>(
          create: (_) => provideReviewViewModel()..fetchReviewsAndAverage(vm.productId),
          child: ProductDetailReviewTab(productId: vm.productId),
        );
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
    return Consumer2<ProductDetailViewModel, WishlistViewModel>(
      builder: (context, vm, wishlistVm, _) {
        return ChangeNotifierProvider<ProductPostListViewModel>(
          create: (_) => provideProductPostListViewModel(vm.productId),
          child: WillPopScope(
            onWillPop: () async {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
              return false;
            },
            child: vm.isLoading ? const CommonLoading() :
            Scaffold(
              backgroundColor: AppColors.white,
              appBar: AppBarHomeSearchCart(
                leading: IconButton(icon: const Icon(Icons.arrow_back),onPressed: (){
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home');
                  }
                },)
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
                                '${vm.storeName}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                          if (vm.discountPercent > 0) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Text(
                                    '${vm.discountPercent}%',
                                    style: const TextStyle(
                                      fontSize: TextSizes.body,
                                      color: AppColors.red,
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
                          ],
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              '${vm.finalPrice.toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (match) => "${match[1]},")}원',
                              style: const TextStyle(
                                fontSize: TextSizes.body,
                                fontWeight: FontWeight.w700,
                                color: AppColors.black,
                              ),
                            ),
                          ),

                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          //   child: Row(
                          //     children: [
                          //       Text(
                          //         '${vm.discountPercent}%',
                          //         style: const TextStyle(
                          //           fontSize: TextSizes.body,
                          //           color: AppColors.black,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //       const SizedBox(width: 8),
                          //       Text(
                          //         '${vm.originalPrice.toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (match) => "${match[1]},")}원',
                          //         style: const TextStyle(
                          //           fontSize: TextSizes.body,
                          //           color: AppColors.black,
                          //           decoration: TextDecoration.lineThrough,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          //   child: Text(
                          //     '${vm.finalPrice.toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (match) => "${match[1]},")}원',
                          //     style: const TextStyle(
                          //       fontSize: TextSizes.body,
                          //       fontWeight: FontWeight.w700,
                          //       color: AppColors.red,
                          //     ),
                          //   ),
                          // ),
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
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0, -2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => wishlistVm.toggleWishlist(vm.productId),
                      child: Row(
                        children: [
                          gapW8,
                          Icon(
                            wishlistVm.isWishlisted(vm.productId)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: wishlistVm.isWishlisted(vm.productId)
                                ? Colors.red
                                : Colors.black,
                            size: 30,
                          ),
                          gapW12,
                          Text(
                            wishlistVm.getWishlistCount(vm.productId).toString(),
                            style: wishlistVm.isWishlisted(vm.productId)
                                ?  context.bodyBold.copyWith(fontSize: 20, color: Colors.red)
                                : context.bodyBold.copyWith(fontSize: 20)
                          ),
                        ],
                      ),
                    ),
                    gapW24,
                    //gapW8,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showOptionBottomSheet(
                            context: context,
                            productId: vm.productId,
                            product: vm.product!,
                            colorOptions: List<String>.from(vm.options['color'] ?? []),
                            sizeOptions: List<String>.from(vm.options['size'] ?? []),
                            originalPrice: vm.originalPrice,
                            discountRate: vm.discountPercent,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.btnPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          minimumSize: const Size(200, 48)
                        ),
                        child: Text(
                          '구매하기',
                          style: context.h1.copyWith(color: Colors.white)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

void showOptionBottomSheet({
  required BuildContext context,
  required String productId,
  required entity.ProductEntity product,
  required List<String> colorOptions,
  required List<String> sizeOptions,
  required int originalPrice,
  required int discountRate,
}) {
  final viewModel = OptionSelectionViewModel(
    colorOptions: colorOptions,
    sizeOptions: sizeOptions,
    originalPrice: originalPrice,
    discountRate: discountRate,
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: viewModel),
          ChangeNotifierProvider.value(value: context.read<CartViewModel>()),
        ],
        child: ProductDetailBottomSheet(productId: productId, product: product),
      );
    },
  );
}
