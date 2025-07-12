import 'package:dio/dio.dart';
import 'package:look_talk/core/network/end_points/home/home_endpoints.dart';
import 'package:look_talk/model/entity/response/bring_sub_category_response.dart';
import 'package:look_talk/model/entity/response/gender_category_id.dart';
import 'package:look_talk/model/entity/response/home_response.dart';
import 'package:look_talk/model/repository/category_detail_repository.dart';
import 'package:look_talk/model/repository/category_repository.dart';

class HomeRepository {
  final Dio _dio;

  final List<String> _targetCategory = ['상의','하의','아우터'];
  final Map<String,String> _categoryId = {};
  final CategoryRepository _categoryRepository;
  final CategoryDetailRepository _categoryDetailRepository;

  HomeRepository(this._dio,this._categoryDetailRepository,this._categoryRepository);

  Future<void> init() async {
      for( final gender in GenderType.values){
        final parentId = GenderCategoryId.id[gender]!;
        final List<BringSubCategoryResponse> subCategories = await _categoryRepository.categoryResult(parentId);

        for (final category in subCategories){
          if(_targetCategory.contains(category.name)){
            _categoryId.putIfAbsent(category.name,()=> category.id);
          }
        }
  }
}

Future<List<Home>> fetchProduct(String categoryName) async{
  final categoryId = _categoryId[categoryName];

  if (categoryName == '전체') {
    final response = await _dio.get(HomeEndpoints.allProduct);
    return HomeResponse.fromJson(response.data).homeProduct;
  } else {
    if (categoryId == null) return [];
  }
  final detailList = await _categoryDetailRepository.categoryResultDetail(categoryId);
  return detailList.map((e) => Home(
    id: e.id,
    name: e.name,
    price: e.price,
    description: e.description,
    storeName: e.storeName,
    thumbnailImage: e.thumbnailImage,
    discount: e.discount,
  )).toList();
    }

}
