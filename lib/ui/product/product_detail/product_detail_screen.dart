import 'package:flutter/material.dart';
import 'package:look_talk/ui/product/product_detail/product_detail_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../view_model/product/product_detail_viewmodel.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductDetailViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.home_outlined, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : (vm.product == null
          ? const Center(child: Text('상품 정보를 불러올 수 없습니다.'))
          : _buildProductContent(context, vm)),
      bottomNavigationBar: vm.product == null ? null : _buildBottomBuyBar(context, vm),
    );
  }

  Widget _buildProductContent(BuildContext context, ProductDetailViewModel vm) {
    final product = vm.product!;
    final numberFormat = NumberFormat('###,###,###,###');

    return DefaultTabController(
      length: vm.tabs.length,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이미지 캐러셀 (임시)
                  Container(
                    height: MediaQuery.of(context).size.width,
                    color: Colors.grey[200],
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '1/${product.imageUrls.length}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  // 상품 정보
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.brand ?? '브랜드 없음', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        const SizedBox(height: 8),
                        Text(product.name, style: const TextStyle(fontSize: 18)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            if (product.discountPercent != null && product.discountPercent! > 0)
                              Text(
                                '${product.discountPercent}%',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFe53935)),
                              ),
                            const SizedBox(width: 8),
                            Text(
                              '${numberFormat.format(product.price)}원',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        if (product.originalPrice != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              '${numberFormat.format(product.originalPrice)}원',
                              style: const TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 화면에 고정되는 탭바
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                TabBar(
                  tabs: vm.tabs.map((name) => Tab(text: name)).toList(),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.black,
                ),
              ),
              pinned: true,
            ),
          ];
        },
        // 탭바 아래 내용
        body: TabBarView(
          children: vm.tabs.map((name) {
            return Center(child: Text('$name 정보가 여기에 표시됩니다.'));
          }).toList(),
        ),
      ),
    );
  }

  // 하단 구매하기 바
  Widget _buildBottomBuyBar(BuildContext context, ProductDetailViewModel vm) {
    final product = vm.product!;

    // ⭐️ 1. BottomAppBar의 높이를 명확하게 제어하기 위해 Container로 감쌉니다.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // SafeArea를 사용하여 시스템 네비게이션 영역을 피합니다.
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    vm.isWishlisted ? Icons.favorite : Icons.favorite_border,
                    color: vm.isWishlisted ? Colors.red : Colors.grey,
                  ),
                  onPressed: vm.toggleWishlist,
                ),
                Text(
                  '${product.wishlistCount + (vm.isWishlisted && !product.isWishlisted ? 1 : 0)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  showOptionBottomSheet(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF192a56), // Dark blue
                  foregroundColor: Colors.white,
                  // ⭐️ 2. 버튼의 높이를 padding으로 조절하여 오버플로우를 방지합니다.
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('구매하기', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// TabBar를 화면 상단에 고정하기 위한 Helper 클래스
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
