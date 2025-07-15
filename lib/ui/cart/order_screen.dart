// lib/ui/main/cart/order_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:look_talk/model/entity/response/cart_response.dart';
import 'package:look_talk/model/entity/request/create_order_request.dart';
import 'package:look_talk/model/entity/response/product_response.dart'; // [수정] product_response import
import 'package:look_talk/view_model/cart/cart_view_model.dart';
import 'package:look_talk/view_model/order/order_view_model.dart';
import 'package:look_talk/view_model/viewmodel_provider.dart';
import 'package:provider/provider.dart';

import '../common/component/primary_button.dart';
import '../common/const/colors.dart';
import '../common/const/gap.dart';
import '../common/const/text_sizes.dart';


class OrderScreen extends StatelessWidget {
  final List<CartItem> productsToOrder;
  const OrderScreen({required this.productsToOrder, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => provideOrderViewModel(),
      child: _OrderScreenContent(productsToOrder: productsToOrder),
    );
  }
}

class _OrderScreenContent extends StatefulWidget {
  final List<CartItem> productsToOrder;
  const _OrderScreenContent({required this.productsToOrder, Key? key}) : super(key: key);

  @override
  State<_OrderScreenContent> createState() => _OrderScreenContentState();
}

class _OrderScreenContentState extends State<_OrderScreenContent> {
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

  void _onPaymentPressed() async {
    final orderViewModel = context.read<OrderViewModel>();
    final cartViewModel = context.read<CartViewModel>();

    final orderItems = widget.productsToOrder.map((cartItem) {
      return OrderItemRequest(
        productId: cartItem.product.id,
        quantity: cartItem.quantity,
        options: {},
        unitPrice: cartItem.cartPrice,
      );
    }).toList();

    final shippingInfo = ShippingInfoRequest(
      recipient: nameController.text,
      phone: phoneController.text,
      address: addressController.text,
    );

    final orderResponse = await orderViewModel.createOrder(
      items: orderItems,
      shippingInfo: shippingInfo,
    );

    if (mounted) {
      if (orderResponse != null) {
        print('주문 성공! Swagger 테스트용 Order ID: ${orderResponse.orderId}');

        await cartViewModel.fetchCart();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('주문이 완료되었습니다. (주문번호: ${orderResponse.orderNumber})')),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('주문 생성에 실패했습니다: ${orderViewModel.error ?? '알 수 없는 오류'}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.productsToOrder.fold<int>(0, (sum, e) => sum + e.totalPrice);
    final isLoading = context.watch<OrderViewModel>().isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('주문 결제', style: TextStyle(fontSize: TextSizes.headline, color: AppColors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: AppColors.black),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
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
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: PrimaryButton(
            text: '${numberFormat.format(totalPrice)}원 결제하기',
            onPressed: isPaymentButtonEnabled && !isLoading ? _onPaymentPressed : null,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(CartItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.boxGrey,
              borderRadius: BorderRadius.circular(8),
              // [수정] thumbnailImageUrl을 사용하고, null일 경우를 대비합니다.
              image: item.product.thumbnailImageUrl != null
                  ? DecorationImage(
                  image: NetworkImage(item.product.thumbnailImageUrl!),
                  fit: BoxFit.cover)
                  : null,
            ),
            // [수정] thumbnailImageUrl이 null일 때 아이콘을 표시합니다.
            child: item.product.thumbnailImageUrl == null
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
                // [수정] store의 name을 사용하고, null일 경우를 대비합니다.
                Text(item.product.store?.name ?? '스토어 없음', style: TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body)),
                gap4,
                Text(item.product.name, style: TextStyle(fontSize: TextSizes.body), maxLines: 1, overflow: TextOverflow.ellipsis),
                gap4,
                // [수정] _buildPriceWidget에 product 객체와 최종 가격을 함께 전달합니다.
                _buildPriceWidget(item.product, item.totalPrice),
                gap4,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.boxGrey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  // [수정] options는 List이므로, 여기서는 수량만 표시하도록 단순화합니다.
                  child: Text(
                      '수량 ${item.quantity}개',
                      style: TextStyle(fontSize: TextSizes.caption, color: Colors.grey[600])),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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

  // [수정] Price 위젯의 로직을 새로운 데이터 모델에 맞게 변경합니다.
  Widget _buildPriceWidget(Product product, int finalPrice) {
    final discountInfo = product.discount;

    // 할인이 없거나, 할인율이 0이면 최종 가격만 표시합니다.
    if (discountInfo == null || discountInfo.value == 0) {
      return Text(
        '${numberFormat.format(finalPrice)}원',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body),
      );
    } else {
      // 할인 적용 시, 원가 계산
      final originalPrice = (finalPrice / (1 - (discountInfo.value / 100))).round();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${numberFormat.format(originalPrice)}원',
            style: const TextStyle(
              fontSize: TextSizes.caption,
              color: AppColors.textGrey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          Row(
            children: [
              Text('${discountInfo.value}%',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: TextSizes.body)),
              gapW8,
              Text(
                '${numberFormat.format(finalPrice)}원',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: TextSizes.body),
              ),
            ],
          ),
        ],
      );
    }
  }
}