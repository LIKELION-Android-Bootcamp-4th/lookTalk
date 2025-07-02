import 'package:flutter/material.dart';
import 'package:look_talk/model/entity/category_entity.dart';
import 'package:look_talk/ui/main/category/categorydetail/detail_listview.dart';
import 'package:look_talk/view_model/category/category_detail/detail_listview_viewmodel.dart';
import 'package:provider/provider.dart';

class CategoryDetailScreen extends StatefulWidget{
  final String mainCategory;
  final List<String> subCategory;
  final String selectedCategory;

  const CategoryDetailScreen({
    required this.mainCategory,
    required this.subCategory,
    required this.selectedCategory
});
  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();


}
class _CategoryDetailScreenState extends State<CategoryDetailScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('${widget.mainCategory}'),
      ),
      body: ChangeNotifierProvider(
        create: (_) => DetailListviewViewmodel(
          subCategories: widget.subCategory,
          initialSubCategory: widget.selectedCategory,
        ),
        child: DetailListview(),
      ),
    );
  }
}
