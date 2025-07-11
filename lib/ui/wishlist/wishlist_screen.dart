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
    // [✅ 수정] 화면이 생성될 때 첫 데이터 로딩을 시작합니다.
    // addPostFrameCallback을 사용하여 build가 완료된 후 안전하게 호출합니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WishlistViewModel>().fetchWishlist();
    });

    // 스크롤 리스너는 그대로 유지합니다.
    _scrollController.addListener(() {
      final viewModel = context.read<WishlistViewModel>();
      if (!viewModel.isLoading &&
          _scrollController.position.pixels >
              _scrollController.position.maxScrollExtent - 200) {
        viewModel.fetchWishlist();
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