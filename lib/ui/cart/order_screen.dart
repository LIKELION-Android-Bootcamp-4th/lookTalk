// lib/ui/main/cart/order_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:look_talk/model/entity/response/cart_response.dart';

import '../common/component/primary_button.dart';
import '../common/const/colors.dart';
import '../common/const/gap.dart';
import '../common/const/text_sizes.dart';

class OrderScreen extends StatefulWidget {
  final List<CartItem> productsToOrder;
  const OrderScreen({required this.productsToOrder, Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  bool agree = false;

  final numberFormat = NumberFormat('###,###,###,###');

  bool get isShippingInfoFilled =>
      nameController.text.trim().isNotEmpty &&
          phoneController.text.trim().isNotEmpty &&
          addressController.text.trim().isNotEmpty;

  bool get isPaymentButtonEnabled => isShippingInfoFilled && agree;


  @override
  void initState() {
    super.initState();
    nameController.addListener(() => setState(() {}));
    phoneController.addListener(() => setState(() {}));
    addressController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.productsToOrder.fold<int>(0, (sum, e) => sum + e.totalPrice);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('주문 결제', style: TextStyle(fontSize: TextSizes.headline, color: AppColors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: AppColors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('주문상품', style: TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body)),
              ),
              gap8,
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.productsToOrder.length,
                itemBuilder: (context, index) {
                  final item = widget.productsToOrder[index];
                  return _buildProductCard(item);
                },
              ),
              Divider(thickness: 1, height: 32, color: AppColors.boxGrey),
              _buildShippingInfoSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PrimaryButton(
            text: '${numberFormat.format(totalPrice)}원 결제하기',
            onPressed: isPaymentButtonEnabled ? () {
              // 결제 진행 로직
            } : null,
          ),
        ),
      ),
    );
  }

  // [✅ UI를 더 컴팩트하게 수정한 상품 카드 위젯]
  Widget _buildProductCard(CartItem item) {
    final discountInfo = item.product.discount;
    return Container(
      // 카드 간 간격 조절
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      // 내부 여백 조절
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 이미지 크기 조절
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.boxGrey,
              borderRadius: BorderRadius.circular(8),
              image: item.product.thumbnailImage != null
                  ? DecorationImage(
                  image: NetworkImage(item.product.thumbnailImage!),
                  fit: BoxFit.cover)
                  : null,
            ),
            child: item.product.thumbnailImage == null
                ? Icon(Icons.image_not_supported_outlined,
                color: AppColors.textGrey, size: 30)
                : null,
          ),
          gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.companyName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body)),
                gap4, // [✅ gap2를 gap4로 수정]
                Text(item.product.name, style: TextStyle(fontSize: TextSizes.body), maxLines: 1, overflow: TextOverflow.ellipsis),
                gap4,
                _buildPriceWidget(discountInfo, item.totalPrice),
                gap4,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.boxGrey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                      '옵션  ${item.product.options['color'] ?? 'N/A'} / ${item.quantity}개',
                      style: TextStyle(fontSize: TextSizes.caption, color: Colors.grey[600])),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 배송 정보 입력 위젯 (이전과 동일)
  Widget _buildShippingInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('배송 정보', style: TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body)),
          gap8,
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: '이름 *'),
          ),
          gap8,
          TextField(
            controller: phoneController,
            decoration: InputDecoration(labelText: '휴대폰 *'),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          gap8,
          TextField(
            controller: addressController,
            decoration: InputDecoration(labelText: '주소 *'),
          ),
          gap16,
          Row(
            children: [
              Checkbox(
                value: agree,
                activeColor: AppColors.primary,
                onChanged: isShippingInfoFilled
                    ? (v) => setState(() => agree = v ?? false)
                    : null,
              ),
              Text('구매동의 (필수)', style: TextStyle(fontSize: TextSizes.caption, color: isShippingInfoFilled ? AppColors.black : Colors.grey)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text('위 주문내용을 확인하였으며 결제에 동의합니다.', style: TextStyle(fontSize: TextSizes.caption)),
          ),
        ],
      ),
    );
  }

  // 가격 표시 위젯 (이전과 동일)
  Widget _buildPriceWidget(Discount? discountInfo, int finalPrice) {
    if (discountInfo == null) {
      return Text(
        '${numberFormat.format(finalPrice)}원',
        style: const TextStyle(fontWeight: FontWeight.bold),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${numberFormat.format(discountInfo.originalPrice)}원',
            style: const TextStyle(
              fontSize: TextSizes.caption,
              color: AppColors.textGrey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          gap4, // [✅ gap2를 gap4로 수정]
          Row(
            children: [
              if (discountInfo.amount > 0)
                Text('${discountInfo.amount}%',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: TextSizes.body)),
              gapW8,
              Text(
                '${numberFormat.format(discountInfo.discountedPrice)}원',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body),
              ),
            ],
          ),
        ],
      );
    }
  }
}
