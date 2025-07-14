import 'package:flutter/cupertino.dart';

import '../../model/entity/response/order_product_summary.dart';
import '../../model/entity/response/search_response.dart';
import '../../model/entity/selected_product.dart';

class SelectedProductViewModel extends ChangeNotifier {
  SelectedProduct? _selected;

  SelectedProduct? get selectedProduct => _selected;

  void selectFromProductSearch(ProductSearch product) {
    _selected = SelectedProduct.fromProductSearch(product);
    notifyListeners();
  }

  void selectFromOrderSummary(OrderProductSummary item) {
    _selected = SelectedProduct.fromOrderSummary(item);
    notifyListeners();
  }

  void deselectProduct() {
    _selected = null;
    notifyListeners();
  }
}
