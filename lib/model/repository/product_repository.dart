import 'package:dio/dio.dart';
import '../entity/product_entity.dart';

class ProductRepository {
  final Dio _dio;

  ProductRepository(this._dio);

  Future<List<ProductEntity>> getProducts() async {
    final path = '/api/seller/products';

    try {
      final response = await _dio.get(path);
      final items = response.data['data']['items'] as List;
      return items.map((item) => ProductEntity.fromJson(item)).toList();
    } catch (e) {
      print('상품 목록 불러오기 실패: $e');
      rethrow;
    }
  }

  Future<ProductEntity> fetchProductDetail(String productId) async {
    final path = '/api/products/$productId';

    try {
      final response = await _dio.get(path);
      final data = response.data['data'] as Map<String, dynamic>;
      return ProductEntity.fromJson(data);
    } catch (e) {
      print('상품 상세 정보 불러오기 실패: $e');
      rethrow;
    }
  }

  // ✅ 추가: 상품 삭제 API
  Future<void> deleteProduct(String productId) async {
    final path = '/api/seller/products/$productId';

    try {
      await _dio.delete(path);
      print('상품 삭제 성공');
    } catch (e) {
      print('상품 삭제 실패: $e');
      rethrow;
    }
  }
}
