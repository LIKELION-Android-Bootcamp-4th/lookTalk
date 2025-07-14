import 'package:look_talk/model/entity/response/search_response.dart';
import 'package:look_talk/model/entity/response/order_product_summary.dart';

class SelectedProduct {
  final String id;
  final String? name;
  final String? storeName;
  final String? imageUrl;

  SelectedProduct({
    required this.id,
    this.name,
    this.storeName,
    this.imageUrl,
  });

  factory SelectedProduct.fromProductSearch(ProductSearch product) {
    return SelectedProduct(
      id: product.id,
      name: product.name,
      storeName: product.storeName,
      imageUrl: product.thumbnailImage,
    );
  }

  factory SelectedProduct.fromOrderSummary(OrderProductSummary item) {
    return SelectedProduct(
      id: item.id,
      name: item.name,
      storeName: item.storeName,
      imageUrl: item.thumbnailImage,
    );
  }
}
