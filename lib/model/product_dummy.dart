import 'package:look_talk/model/entity/product_entity.dart';

class ProductRepository {
  static List<Product> dummyProducts() {
    return  [
      Product(name: '[w] 크롱 그래픽 티셔츠 (그레이) S', code: '2025063001'),
      Product(name: '[w] 크롱 그래픽 티셔츠 (그레이) M', code: '2025063002'),
      Product(name: '[w] 크롱 그래픽 티셔츠 (그레이) L', code: '2025063003'),
      Product(name: '[m] 경량 코튼 밴딩 팬츠 (카키) S', code: '2025063004'),
    ];
  }
}