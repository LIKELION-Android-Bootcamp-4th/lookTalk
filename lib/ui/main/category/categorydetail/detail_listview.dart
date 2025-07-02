import 'package:flutter/material.dart';
import 'package:look_talk/view_model/category/category_detail/detail_listview_viewmodel.dart';
import 'package:provider/provider.dart';

class DetailListview extends StatelessWidget {



  @override
  Widget build(BuildContext context) {

    final viewModel = Provider.of<DetailListviewViewmodel>(context);

    if(viewModel..isEmpty){
      return Center(child: Text("아이템이 없습니다."));
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("${items[index]}"),
        );
      },
    );
  }


}