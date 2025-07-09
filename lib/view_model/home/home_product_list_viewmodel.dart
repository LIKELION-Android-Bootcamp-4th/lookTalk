import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import '../../model/entity/product_entity.dart';

class HomeProductListViewModel extends ChangeNotifier {
  final Dio _dio;
  HomeProductListViewModel(this._dio);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Product> _products = [];
  List<Product> get products => List.unmodifiable(_products);

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    const path = '/api/products';

    debugPrint('--- 홈 상품 목록 조회 요청 (DioClient) ---');
    debugPrint('Path: $path');
    debugPrint('------------------');

    try {
      final response = await _dio.get(path);

      debugPrint('홈 상품 목록 응답 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> dataMap = response.data['data'] as Map<String, dynamic>? ?? {};
        final List<dynamic> productListJson = dataMap['items'] as List<dynamic>? ?? [];

        _products = productListJson.map((json) => Product.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        _products = [];
      }
    } on DioException catch (e) {
      debugPrint('홈 상품 목록 조회 중 dio 오류: ${e.response?.data}');
      _products = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
