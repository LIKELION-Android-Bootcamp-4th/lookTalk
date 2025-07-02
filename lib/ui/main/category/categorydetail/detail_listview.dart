import 'package:flutter/material.dart';
import 'package:look_talk/view_model/category/category_detail/detail_listview_viewmodel.dart';
import 'package:provider/provider.dart';

class DetailListview extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
   final viewmodel = Provider.of<DetailListviewViewmodel>(context);

   if(viewmodel.subCategories.isEmpty){
     return Center(child: Text("설정이 잘못되었습니다."));
   }

   return SingleChildScrollView(
     scrollDirection: Axis.horizontal,
     child: Row(
       children: viewmodel.subCategories.map((category){

         return GestureDetector(
           onTap: () => viewmodel.changeSubCategory(category),
           child: Container(
             padding: EdgeInsets.only(right: 12),
             child: Text(
               category
               ,
               style: TextStyle(
                 fontSize: 30,
                 color: viewmodel.isSelected(category) ? Colors.blue : Colors.grey
             ),
             ),
           ),
         );
       }
       ).toList()
     ),
   );
  }


}