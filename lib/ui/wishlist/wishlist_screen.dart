import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/common/const/text_sizes.dart';
import 'package:look_talk/ui/wishlist/wishlist_item_widget.dart';
import 'package:look_talk/view_model/wishlist/wishlist_view_model.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 200) {
        // [✅ 수정] ViewModel을 가져와서 로딩 중이 아닐 때만 다음 페이지를 호출하도록 변경
        final viewModel = context.read<WishlistViewModel>();
        if (!viewModel.isLoading) {
          viewModel.fetchWishlist();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WishlistViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('찜', style: TextStyle(fontSize: TextSizes.headline, color: AppColors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.go('/search');
            },
            icon: const Icon(Icons.search, color: AppColors.black),
          ),
          IconButton(
            onPressed: () {
              context.go('/cart');
            },
            icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.black),
          ),
        ],
      ),
      body: _buildBody(viewModel),
    );
  }

  Widget _buildBody(WishlistViewModel viewModel) {
    // 첫 로딩 시
    if (viewModel.isFirstLoad) {
      return const Center(child: CircularProgressIndicator());
    }

    // 에러 발생 시 (아이템이 하나도 없을 때)
    if (viewModel.error != null && viewModel.items.isEmpty) {
      return Center(child: Text('오류가 발생했습니다: ${viewModel.error}'));
    }

    // 찜 목록이 비었을 때
    if (viewModel.items.isEmpty) {
      return const Center(child: Text('찜한 상품이 없습니다.', style: TextStyle(fontSize: TextSizes.body, color: AppColors.textGrey)));
    }

    // 찜 목록 표시
    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: viewModel.items.length + (viewModel.hasNext ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == viewModel.items.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final item = viewModel.items[index];
          return WishlistItemWidget(item: item);
        },
      ),
    );
  }
}