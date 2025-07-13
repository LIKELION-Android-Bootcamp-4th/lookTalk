import 'package:dio/dio.dart';
import '../entity/product_entity.dart';

class ProductRepository {
  final Dio _dio;

  ProductRepository(this._dio);

  Future<List<Product>> getProducts() async {
    final path = '/api/seller/products';

    try {
      final response = await _dio.get(path);
      final items = response.data['data']['items'] as List;

      return items.map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      print('상품 목록 불러오기 실패: $e');
      rethrow;
    }
  }

  Future<Product> fetchProductDetail(String productId) async {
    final path = '/api/products/$productId';

    try {
      final response = await _dio.get(path);
      final data = response.data['data'] as Map<String, dynamic>;
      return Product.fromJson(data);
    } catch (e) {
      print('상품 상세 정보 불러오기 실패: $e');
      rethrow;
    }
  }
}
