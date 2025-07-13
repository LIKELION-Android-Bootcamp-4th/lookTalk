import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';

import '../../../../../view_model/mypage_view_model/search_my_product_list_viewmodel.dart';

class ManageWidget extends StatelessWidget {
  final String orderId;
  final String status;
  final dynamic orderItem;
  final int? totalAmount;
  final SearchMyProductListViewmodel viewModel;


  const ManageWidget({
    super.key,
    required this.orderId,
    required this.status,
    required this.orderItem,
    this.totalAmount,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {


    final imageUrl = orderItem.thumbnailImage;
    final isValidImage = imageUrl != null && imageUrl.trim().isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              isValidImage
                  ? Image.network(
                imageUrl!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 100, color: Colors.grey),
              )
                  : const Icon(Icons.image, size: 100, color: Colors.grey),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(orderItem.storeName ?? '', style: context.bodyBold),
                    const SizedBox(height: 4),
                    Text(orderItem.name, style: context.body),
                    const SizedBox(height: 4),
                    Text('옵션: ${orderItem.size ?? "옵션 없음"}'),
                    const SizedBox(height: 4),
                    Text('${orderItem.price}원  수량: ${totalAmount ?? 0}개' ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),


          Row(
            children: [
              Spacer(),
              _buildButtonsByStatus(status),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildButtonsByStatus(String status) {
    switch (status) {
      case 'pending':
        return Row(
          children: [
            _actionButton('반품신청'),
            const SizedBox(width: 8),
            _actionButton('취소하기'),
          ],
        );
      case 'confirmed':
      case 'preparing':
      case 'shipped':
        return Row(
          children: [
            _actionButton('반품신청'),
            const SizedBox(width: 8),
            _actionButton('취소하기'),
          ],
        );
      case 'delivered':
        return Row(
          children: [
            _actionButton('반품신청'),
            const SizedBox(width: 8),
            _actionButton('리뷰작성'),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _actionButton(String label) {
    return OutlinedButton(
      onPressed: () {
        switch (label){
          case '취소하기' : viewModel.cancelOrder(orderId);
          break;
          case '반품신청' : viewModel.refund(orderId);
          break;
          case '리뷰 작성' :
            break;
        }
        // TODO: 버튼 동작 정의
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }


}
