import 'package:flutter/material.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_search_cart.dart';
import 'package:look_talk/ui/common/const/colors.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/manage_product/cancel_tab.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/manage_product/filter_tab.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/manage_product/order_tab.dart';
import 'package:look_talk/ui/main/mypage/mypage_customer/manage_product/return_product_tab.dart';
import 'package:look_talk/view_model/mypage_view_model/search_my_product_list_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:look_talk/ui/product/review/review_write_screen.dart';

import 'manage_widget.dart';


class ManageProductScreen extends StatefulWidget {
  const ManageProductScreen({super.key});

  @override
  State<ManageProductScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<ManageProductScreen> {
  late SearchMyProductListViewmodel viewModel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel = context.read<SearchMyProductListViewmodel>();
      viewModel.refresh();
    });

  }



  @override
  Widget build(BuildContext context) {
    viewModel = context.watch<SearchMyProductListViewmodel>();

    return Scaffold(
      appBar: AppBarSearchCart(
        title: '주문/반품/취소',

      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: viewModel.orders.length,
        itemBuilder: (context, index) {
          final order = viewModel.orders[index];
          final checkRefund = order.refundInfo ? "refunding" : order.status;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 날짜
                    Text(
                      order.createdAt.split('T').first,
                      style: context.h1.copyWith(color: AppColors.black),
                    ),
                    const SizedBox(height: 4),

                    // 상태 라벨
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      height: 43,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: (order.refundInfo && order.status == 'refunded')
                       ? _statusBgColor('refunded')
                       : _statusBgColor(checkRefund),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                              (order.refundInfo && order.status == 'refunded')
                              ? _statusLabel('refunded')
                              : _statusLabel(checkRefund),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ...order.items.map((item) => ManageWidget(
            orderId : order.oderId,
            status: (order.refundInfo && order.status == 'refunded') ?'refunded' : checkRefund,
            orderItem: item,
            viewModel: viewModel,
          )),
            ],
          );
        },
      ),
    );
  }


  String _statusLabel(String status) {
    const map = {
      'pending': '결제완료',
      'confirmed': '주문확정',
      'preparing': '상품준비',
      'shipped': '배송시작',
      'delivered': '배송완료',
      'cancelled': '취소됨',
      'refunding': '환불요청',
      'refunded': '환불완료',
    };
    return map[status] ?? status;
  }

  Color _statusBgColor(String status) {
    switch (status) {
      case 'confirmed':
      case 'preparing':
        return Colors.orange.shade100;
      case 'shipped':
        return Colors.blue.shade100;
      case 'delivered':
        return Colors.green.shade100;
      case 'cancelled':
        return Colors.red.shade100;
      case 'refunded':
        return Colors.purple.shade100;
      case 'refunding' :
        return Colors.purple.shade500;
      default:
        return Colors.grey.shade200;
    }
  }

  }
