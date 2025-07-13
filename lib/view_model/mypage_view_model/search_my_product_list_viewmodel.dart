import 'package:flutter/widgets.dart';
import 'package:look_talk/model/entity/response/order_list_response.dart';
import 'package:look_talk/model/repository/order_list_repository.dart';

class SearchMyProductListViewmodel with ChangeNotifier {
  final OrderListRepository _repository;

  SearchMyProductListViewmodel({required OrderListRepository repository})
      : _repository = repository {
    _init();
  }

  List<OrderListResponse> _orders = [];
  List<OrderListResponse> get orders => _orders;

  Future<void> _init() async {
    final response = await _repository.searchResult();
    _orders = response;
    notifyListeners();
  }

  Future<void> cancelOrder(String orderId) async{
    try{
      await _repository.cancelOrder(orderId);

      _orders = await _repository.searchResult();
      notifyListeners();
    }catch(e){
      print("에러 발생 ${e}");
    }
  }

  Future<void> refund(String orderId) async{
    try{
      await _repository.refund(orderId);

      _orders = await _repository.searchResult();
      notifyListeners();
    }catch(e){
      print("에러 발생 ${e}");
    }
  }
}
