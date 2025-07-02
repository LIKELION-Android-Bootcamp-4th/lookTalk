import 'package:flutter/material.dart';
import 'package:look_talk/model/category_dummydata.dart';
import 'package:look_talk/model/entity/category_entity.dart';
import 'package:look_talk/ui/main/category/categorydetail/detail_listview.dart';

class CategoryDetailScreen extends StatefulWidget{
  final String mainCategory;
  final String subCategory;
  final String gender;

  const CategoryDetailScreen({
    required this.mainCategory,
    required this.subCategory,
    required this.gender
});
  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();


}
class _CategoryDetailScreenState extends State<CategoryDetailScreen>{
  List<String> category = [];

  @override
  void initState() {
    super.initState();
    loadItems();
  }
  void loadItems(){
    List<CategoryEntity> categories = widget.gender == '남자' ? manCategory : womanCategory;

    final selectedCategories = categories.firstWhere((cat) =>
    cat.mainCategory == widget.mainCategory,
    orElse: () => CategoryEntity(id: 0, mainCategory: '', subCategory: [])
    );
    List<String> subItems = selectedCategories.subCategory;

    category = subItems.where((item) => item == widget.subCategory).toList();
    
    setState(() {
      {}});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('${widget.mainCategory}'),
      ),
      body: DetailListview(items: category),
    );
  }
}


