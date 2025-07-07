import 'package:flutter/material.dart';
import '../common/const/colors.dart';
import '../common/const/gap.dart';
import '../common/const/text_sizes.dart';
import '../common/component/primary_button.dart';
import 'order_screen.dart';

class CartItem {
  final String id;
  final String brand;
  final String name;
  final String option;
  final int originPrice;
  final int salePrice;
  bool selected;

  CartItem({
    required this.id,
    required this.brand,
    required this.name,
    required this.option,
    required this.originPrice,
    required this.salePrice,
    this.selected = false,
  });
}

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [
    CartItem(
      id: '1',
      brand: 'Auralee',
      name: '남자 코튼 니트 폴로',
      option: '그린 / L / 1개',
      originPrice: 450500,
      salePrice: 225250,
    ),
    // 더미 상품 추가 가능
  ];

  bool get isAllSelected => cartItems.every((e) => e.selected);
  int get selectedCount => cartItems.where((e) => e.selected).length;
  int get totalSelectedPrice =>
      cartItems.where((e) => e.selected).fold(0, (sum, e) => sum + e.salePrice);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('장바구니', style: TextStyle(fontSize: TextSizes.headline, color: AppColors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: AppColors.black),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (final e in cartItems) {
                  e.selected = false;
                }
              });
            },
            child: Text('선택 삭제', style: TextStyle(color: AppColors.black, fontSize: TextSizes.body)),
          ),
        ],
      ),
      body: Column(
        children: [
          gap16,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Checkbox(
                  value: isAllSelected,
                  onChanged: (v) {
                    setState(() {
                      for (final e in cartItems) {
                        e.selected = v ?? false;
                      }
                    });
                  },
                  activeColor: AppColors.primary,
                ),
                Text('전체 선택(${selectedCount}/${cartItems.length})', style: TextStyle(fontSize: TextSizes.body)),
                Spacer(),
                // 선택 삭제 버튼은 AppBar에도 있음
              ],
            ),
          ),
          gap16,
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8),
              itemCount: cartItems.length,
              itemBuilder: (context, i) {
                final item = cartItems[i];
                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  color: AppColors.white,
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: item.selected,
                          onChanged: (v) => setState(() => item.selected = v ?? false),
                          activeColor: AppColors.primary,
                        ),
                        gapW8,
                        Container(
                          width: 70,
                          height: 90,
                          decoration: BoxDecoration(
                            color: AppColors.boxGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.image, color: AppColors.textGrey, size: 36),
                        ),
                        gapW16,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(item.brand, style: TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body)),
                                  Spacer(),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        cartItems.removeAt(i);
                                      });
                                    },
                                    child: Icon(Icons.close, color: AppColors.textGrey, size: 22),
                                  ),
                                ],
                              ),
                              gap4,
                              Text(item.name, style: TextStyle(fontSize: TextSizes.body)),
                              gap8,
                              Text(
                                '${item.originPrice.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}원',
                                style: TextStyle(
                                  fontSize: TextSizes.caption,
                                  color: AppColors.textGrey,
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              gap4,
                              Row(
                                children: [
                                  Text('50%', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                  gapW8,
                                  Text(
                                    '${item.salePrice.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}원',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              gap8,
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.boxGrey,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Text('옵션', style: TextStyle(color: AppColors.textGrey, fontSize: TextSizes.caption)),
                                    gapW8,
                                    Text(item.option, style: TextStyle(fontSize: TextSizes.caption)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 16, color: Colors.black.withOpacity(0.04))],
            ),
            padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text('결제 예상 금액', style: TextStyle(fontSize: TextSizes.body)),
                    Spacer(),
                    Text(
                      '${totalSelectedPrice.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')} 원',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body),
                    ),
                  ],
                ),
                gap16,
                PrimaryButton(
                  text: '구매하기',
                  onPressed: selectedCount > 0
                      ? () {
                    final selectedIds = cartItems
                        .where((e) => e.selected)
                        .map((e) => e.id)
                        .toList();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderScreen(selectedIds: selectedIds),
                      ),
                    );
                  }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
