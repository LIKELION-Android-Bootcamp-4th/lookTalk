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

  Future<void> cancelOrder(String orderId) async{
    try{
      await _dio.patch(
        "${MyPage.cancelOrder}/${orderId}/cancel",
        data: {
          "cancelReason": "test1111"
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
          "reason": "test1111"
        },
      );
    }catch(e){
      print("에러발생${e}");
    }
  }

}
