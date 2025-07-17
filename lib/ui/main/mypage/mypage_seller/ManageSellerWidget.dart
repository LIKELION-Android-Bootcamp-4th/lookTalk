import 'dart:core';
import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/component/common_snack_bar.dart';
import 'package:look_talk/view_model/mypage_view_model/seller_manage_viewmodel.dart';

class Managesellerwidget extends StatelessWidget {
  final String orderId;
  final String status;
  final dynamic orderItem;
  final int? quantity;
  final SellerManageViewmodel viewModel;

  const Managesellerwidget({
    super.key,
    required this.orderId,
    required this.status,
    required this.orderItem,
    this.quantity,
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
                    Text('${orderItem.price}원  수량: ${quantity ?? 0}개'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Spacer(),
              _buildStateChangeStatus(status, (newStatus, {trackingNumber}) {
                viewModel.changeStatus(orderId, newStatus, trackingNumber: trackingNumber);
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStateChangeStatus(
      String status,
      Function(String, {String? trackingNumber}) newStatus,
      ) {
    final Map<String, List<String>> statusTransitions = {
      'pending': ['confirmed', 'cancelled'],
      'confirmed': ['preparing', 'cancelled'],
      'preparing': ['shipped', 'cancelled'],
      'shipped': ['delivered'],
      'delivered': ['refunded'],
    };

    final List<String> nextStatuses = statusTransitions[status] ?? [];

    return StatefulBuilder(builder: (context, setState) {
      String? selected;

      return DropdownButton<String>(
        hint: Text(_statusToText(status)),
        value: selected,
        items: nextStatuses
            .map((status) => DropdownMenuItem(
          value: status,
          child: Text(_statusToText(status)),
        ))
            .toList(),
        onChanged: (value) async {
          if (value != null) {
            setState(() {
              selected = value;
            });

            if (value == "shipped") {
              final trackingNumber = await showDialog<String>(
                context: context,
                builder: (context) {
                  final controller = TextEditingController();
                  return AlertDialog(
                    title: Text("송장 번호 입력"),
                    content: TextField(
                      controller: controller,
                      decoration: InputDecoration(hintText: "송장 번호를 입력하세요"),
                    ),
                    actions: [
                      TextButton(
                        child: Text("취소"),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      ElevatedButton(
                        child: Text("확인"),
                        onPressed: () {
                          final input = controller.text.trim();
                          Navigator.of(context).pop(input);
                        },
                      ),
                    ],
                  );
                },
              );

              if (trackingNumber != null && trackingNumber.isNotEmpty) {
                newStatus(value, trackingNumber: trackingNumber);
              } else {
                setState(() {
                  selected = null;
                });
                CommonSnackBar.show(context, message: '송장 번호가 입력되지 않았습니다.');
              }
            } else {
              newStatus(value);
            }
          }
        },
        style: const TextStyle(fontSize: 13, color: Colors.black),
        underline: Container(height: 0),
        borderRadius: BorderRadius.circular(15),
      );
    });
  }

  String _statusToText(String status) {
    switch (status) {
      case 'pending' :
        return '주문 요청';
      case 'confirmed':
        return '주문 확정';
      case 'preparing':
        return '상품 준비';
      case 'shipped':
        return '배송 시작';
      case 'delivered':
        return '배송 완료';
      case 'cancelled':
        return '주문 취소';
      case 'refunded':
        return '환불 처리';
      default:
        return status;
    }
  }
}
