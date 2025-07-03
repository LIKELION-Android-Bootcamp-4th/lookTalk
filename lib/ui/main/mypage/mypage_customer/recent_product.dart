
import 'package:flutter/material.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_search_cart.dart';

class RecentProduct extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBarSearchCart(title: '최근 본 상품',),
     body: GridView.builder(
       padding: EdgeInsets.all(8),
       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
           crossAxisCount: 3,
           crossAxisSpacing: 8,
           mainAxisSpacing: 8,
           childAspectRatio: 1
       ),
       itemCount: 100,
       itemBuilder: (context, index){
         return Container(
           color: Colors.grey[300],
           height: 100,
         );
       },

     ),
   );
  }
}