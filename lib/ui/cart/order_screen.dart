import 'package:flutter/material.dart';
import '../common/const/colors.dart';
import '../common/const/gap.dart';
import '../common/const/text_sizes.dart';
import '../common/component/primary_button.dart';

// 더미 데이터(실제 서비스에서는 서버 연동)
final dummyProducts = [
  {
    'id': '1',
    'brand': 'Auralee',
    'name': '남자 코튼 니트 폴로',
    'option': '그린 / L / 1개',
    'originPrice': 450500,
    'salePrice': 225250,
  }
];

class OrderScreen extends StatefulWidget {
  final List<String> selectedIds;
  const OrderScreen({required this.selectedIds, Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // 상태값
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  bool agree = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  bool get isFormValid =>
      nameController.text.trim().isNotEmpty &&
          phoneController.text.trim().isNotEmpty &&
          addressController.text.trim().isNotEmpty &&
          agree;

  @override
  Widget build(BuildContext context) {
    final products = dummyProducts.where((p) => widget.selectedIds.contains(p['id'])).toList();
    final totalPrice = products.fold<int>(0, (sum, e) => sum + (e['salePrice'] as int));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('주문 결제', style: TextStyle(fontSize: TextSizes.headline, color: AppColors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: AppColors.black),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gap16,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('주문상품', style: TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body)),
            ),
            gap8,
            ...products.map((item) => Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80, height: 96,
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
                        Text(item['brand'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body)),
                        gap4,
                        Text(item['name'] as String, style: TextStyle(fontSize: TextSizes.body)),
                        gap8,
                        Text(
                          '${item['originPrice'].toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}원',
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
                              '${item['salePrice'].toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}원',
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
                              Text(item['option'] as String, style: TextStyle(fontSize: TextSizes.caption)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            Divider(thickness: 1, height: 32, color: AppColors.boxGrey),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('배송 정보', style: TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body)),
            ),
            gap8,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: '이름 *'),
                    onChanged: (_) => setState(() {}),
                  ),
                  gap8,
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: '휴대폰 *'),
                    keyboardType: TextInputType.phone,
                    onChanged: (_) => setState(() {}),
                  ),
                  gap8,
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: '주소 *'),
                    onChanged: (_) => setState(() {}),
                  ),
                ],
              ),
            ),
            gap16,
            Row(
              children: [
                gapW16,
                Checkbox(
                  value: agree,
                  onChanged: (v) => setState(() => agree = v ?? false),
                  activeColor: AppColors.primary,
                ),
                Text('구매동의 (필수)', style: TextStyle(fontSize: TextSizes.caption)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('위 주문내용을 확인하였으며 결제에 동의합니다.', style: TextStyle(fontSize: TextSizes.caption)),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PrimaryButton(
                text: '${totalPrice.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}원 결제하기',
                onPressed: isFormValid ? () {
                  // 결제 진행
                } : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
