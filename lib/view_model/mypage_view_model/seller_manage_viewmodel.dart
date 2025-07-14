import 'package:flutter/widgets.dart';
import 'package:look_talk/model/entity/response/order_list_response.dart';
import 'package:look_talk/model/repository/order_list_repository.dart';

class SellerManageViewmodel with ChangeNotifier {
  final OrderListRepository _repository;

  SellerManageViewmodel({required OrderListRepository repository})
      : _repository = repository {
    _init();
  }

  List<OrderListResponse> _orders = [];
  List<OrderListResponse> get orders => _orders;

  Future<void> _init() async {
    final response = await _repository.searchOrderResult();
    _orders = response;
    notifyListeners();
  }

  Future<void> changeStatus(String orderId,String status) async{
    try{
      await _repository.changeStatus(orderId,status);

      _orders = await _repository.searchOrderResult();
      notifyListeners();
    }catch(e){
      print("에러 발생 ${e}");
    }
  }

}