import 'package:flutter/material.dart';

class CategoryDetailScreen extends StatefulWidget{
  final String mainCategory;
  final String subCategory;

  const CategoryDetailScreen({
    required this.mainCategory,
    required this.subCategory
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
    );
  }
}


