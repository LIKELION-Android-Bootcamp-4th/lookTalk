import 'package:look_talk/model/category_dummydata.dart';
import 'package:look_talk/model/entity/category_entity.dart';

class CategoryRepository {
  Future<List<CategoryEntity>> getCategories(String gender) async{
    return gender == "남자" ? manCategory : womanCategory;
  }
}