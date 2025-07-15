import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/component/common_modal.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:look_talk/ui/common/const/text_sizes.dart';
import 'package:look_talk/view_model/cart/cart_view_model.dart'; // [추가] CartViewModel import
import 'package:look_talk/view_model/wishlist/wishlist_view_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:collection';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WishlistViewModel>().fetchWishlist(isRefresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WishlistViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '찜',
          style: TextStyle(
            fontSize: TextSizes.headline,
            color: AppColors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.push('/search'),
            icon: const Icon(Icons.search, color: AppColors.black),
          ),
          IconButton(
            onPressed: () => context.push('/cart'),
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.black,
            ),
          ),
        ],
      ),
      body: _buildBody(context, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, WishlistViewModel viewModel) {
    if (viewModel.isFirstLoad) {
      return const Center(child: CircularProgressIndicator());
    }
    if (viewModel.error != null) {
      return Center(child: Text('오류가 발생했습니다.\n${viewModel.error}'));
    }
    if (viewModel.items.isEmpty) {
      return const Center(
        child: Text(
          '찜한 상품이 없습니다.',
          style: TextStyle(fontSize: TextSizes.body, color: AppColors.textGrey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      child: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
          childAspectRatio: 0.6,
        ),
        itemCount: viewModel.items.length,
        itemBuilder: (context, index) {
          final item = viewModel.items[index];
          return _buildGridItem(context, item, NumberFormat('###,###,###,###'));
        },
      ),
    );
  }

  // void _showDeleteConfirmDialog(var item) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext dialogContext) {
  //       return AlertDialog(
  //         title: const Text("찜 삭제"),
  //         content: Text("'${item.name}' 상품을 찜 목록에서 삭제하시겠습니까?"),
  //         actions: [
  //           TextButton(
  //             child: const Text("취소"),
  //             onPressed: () {
  //               Navigator.of(dialogContext).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: Text("삭제", style: TextStyle(color: Colors.red[600])),
  //             onPressed: () {
  //               context.read<WishlistViewModel>().removeItem(item.productId);
  //               Navigator.of(dialogContext).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showDeleteConfirmDialog(var item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CommonModal(
          title: "찜 삭제",
          content: "'${item.name}' 상품을 찜 목록에서 삭제하시겠습니까?",
          confirmText: "삭제",
          onConfirm: () {
            context.read<WishlistViewModel>().removeItem(item.productId);
            Navigator.of(dialogContext).pop();
          },
        );
      },
    );
  }

  // [추가] 장바구니 추가 확인 다이얼로그를 보여주는 함수
  void _showAddToCartConfirmDialog(var item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("장바구니 추가"),
          content: Text("'${item.name}' 상품을 장바구니에 추가하시겠습니까?"),
          actions: [
            TextButton(
              child: const Text("취소"),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(
                "추가",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                // CartViewModel의 addItem 메소드를 호출
                context.read<CartViewModel>().addItem(
                  productId: item.productId,
                  unitPrice: item.price,
                );
                Navigator.of(dialogContext).pop();

                // 추가 완료 SnackBar 보여주기
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("'${item.name}'이(가) 장바구니에 추가되었습니다."),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildGridItem(
    BuildContext context,
    var item,
    NumberFormat numberFormat,
  ) {
    final bool hasImage =
        item.thumbnailImageUrl != null && item.thumbnailImageUrl!.isNotEmpty;

    return InkWell(
      onTap: () {
        context.push('/product/${item.productId}');
      },
      onLongPress: () {
        _showDeleteConfirmDialog(item);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 1 / 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    image: hasImage
                        ? DecorationImage(
                            image: NetworkImage(item.thumbnailImageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: !hasImage
                      ? const Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: InkWell(
                  onTap: () {
                    _showDeleteConfirmDialog(item);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ),
              // [추가] 오른쪽 하단에 장바구니 아이콘 배치
              // Positioned(
              //   bottom: 4,
              //   right: 4,
              //   child: InkWell(
              //     onTap: () {
              //       _showAddToCartConfirmDialog(item);
              //     },
              //     child: Container(
              //       padding: const EdgeInsets.all(4),
              //       // [수정] 배경을 투명하게 만들기 위해 decoration 제거
              //       // decoration: BoxDecoration(...)
              //       child: const Icon(
              //         Icons.add_shopping_cart,
              //         color: Colors.black, // [수정] 아이콘 색상을 검은색으로 변경
              //         size: 20, // 아이콘 크기를 약간 키웠습니다.
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          gap8,
          if (item.storeName != null) ...[
            Text(
              item.storeName!,
              style: context.h1.copyWith(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            gap4,
          ],
          Text(
            item.name,
            style: context.bodyBold.copyWith(fontSize: 10),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          gap4,
          Row(
            children: [
              if (item.discountRate != null && item.discountRate! > 0) ...[
                Text(
                  "${item.discountRate}% ",
                  style: context.bodyBold.copyWith(
                    fontSize: 12,
                    color: Colors.red,
                  ),
                ),
                gapW4,
                Flexible(
                  child: Text(
                    "${numberFormat.format(item.price * (100 - item.discountRate!) / 100)}원",
                    style: context.h1.copyWith(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ] else ...[
                Flexible(
                  child: Text(
                    "${numberFormat.format(item.price)}원",
                    style: context.h1.copyWith(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
