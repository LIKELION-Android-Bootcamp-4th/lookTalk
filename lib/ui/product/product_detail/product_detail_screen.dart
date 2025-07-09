import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_model/product/product_detail_viewmodel.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductDetailViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(vm.product?.name ?? '상품 상세 정보'),
      ),
      body: _buildBody(vm),
    );
  }

  Widget _buildBody(ProductDetailViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.product == null) {
      return const Center(child: Text('상품 정보를 불러올 수 없습니다.'));
    }

    final product = vm.product!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상품 이미지
          Container(
            height: 300,
            width: double.infinity,
            color: Colors.grey[200],
            // child: Image.network(product.imageUrl),
          ),
          const SizedBox(height: 24),

          Text(
            product.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Text(
            '상품 코드: ${product.code}',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const Divider(height: 48),

        ],
      ),
    );
  }
}
