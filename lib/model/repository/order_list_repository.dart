import 'package:dio/dio.dart';
import 'package:look_talk/model/entity/response/order_list_response.dart';

import '../../core/network/end_points/mypage.dart';

class OrderListRepository {
  final Dio _dio;

  OrderListRepository(this._dio);


  Future<List<OrderListResponse>> searchResult() async {
    try {
      final response = await _dio.get(
        MyPage.allOrderProduct
      );
      final data = response.data['data']['items'] as List;
      return data
          .map((orderJson) => OrderListResponse.fromJson(orderJson))
          .toList();
    }catch(e){
      throw Exception('검색이 되지 않습니다. $e');
    }
  }
  Future<List<OrderListResponse>> searchOrderResult() async {
    try {
      final response = await _dio.get(
          MyPage.orderSellerSearch
      );
      final data = response.data['data']['items'] as List;
      return data
          .map((orderJson) => OrderListResponse.fromJson(orderJson))
          .toList();
    }catch(e){
      throw Exception('검색이 되지 않습니다. $e');
    }
  }

  Future<void> cancelOrder(String orderId) async{
    try{
      await _dio.patch(
        "${MyPage.cancelOrder}/${orderId}/cancel",
        data: {
          "reason": "단순 변심",
          "detailReason": "다른 상품을 주문하려고 합니다"
        },
      );
    }catch(e){
      print("에러발생${e}");
    }
  }

  Future<void> changeStatus(String orderId, String status) async{
    try{
      await _dio.patch(
        "${MyPage.orderChangeStatus}/${orderId}/status",
        data: {
          "status": "${status}",
          "note": "판매자 처리중"
        },
      );
    }catch(e){
      print("에러발생${e}");
    }
  }

  Future<void> refund(String orderId) async{
    try{
      await _dio.patch(
        "${MyPage.cancelOrder}/${orderId}/refund",
        data: {
          "reason": "단순 변심",
          "detailReason": "다른 상품을 주문하려고 합니다"
        },
      );
    }catch(e){
      print("에러발생${e}");
    }
  }

}
