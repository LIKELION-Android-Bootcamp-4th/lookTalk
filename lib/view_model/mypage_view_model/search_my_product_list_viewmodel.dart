import 'package:flutter/widgets.dart';
import 'package:look_talk/model/entity/response/order_list_response.dart';
import 'package:look_talk/model/repository/order_list_repository.dart';

class SearchMyProductListViewmodel with ChangeNotifier {
  final OrderListRepository _repository;

  SearchMyProductListViewmodel({required OrderListRepository repository})
      : _repository = repository {
    fetchOrderList(); // 초기화 시 데이터 로드
  }

  List<OrderListResponse> _orders = [];
  List<OrderListResponse> get orders => _orders;

  /// 주문 목록 조회 (초기화 및 새로고침용)
  Future<void> fetchOrderList() async {
    try {
      final response = await _repository.searchResult();
      _orders = response;
      notifyListeners();
    } catch (e) {
      print("주문 목록 불러오기 실패: $e");
    }
  }

  /// 외부에서 강제 새로고침 호출용
  void refresh() {
    fetchOrderList();
  }

  /// 주문 취소
  Future<void> cancelOrder(String orderId) async {
    try {
      await _repository.cancelOrder(orderId);
      await fetchOrderList();
    } catch (e) {
      print("주문 취소 중 에러 발생: $e");
    }
  }

  /// 반품 신청
  Future<void> refund(String orderId) async {
    try {
      await _repository.refund(orderId);
      await fetchOrderList();
    } catch (e) {
      print("반품 신청 중 에러 발생: $e");
    }
  }
}
