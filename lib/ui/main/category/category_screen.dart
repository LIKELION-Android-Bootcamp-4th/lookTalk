import 'package:flutter/material.dart';

import 'package:look_talk/ui/main/category/gender_toggle.dart';
import 'package:look_talk/view_model/category/category_select_viewmodel.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategorySelectViewmodel(),
      child: Scaffold(
        appBar: AppBar(

          title: Text("카테고리"),
          titleTextStyle:
          TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 16),
                child: Row(
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                      IconButton(onPressed: () {},
                          icon: Icon(Icons.shopping_cart_outlined)),
                    ]
                )
            )
          ],
        ),
        body: Consumer<CategorySelectViewmodel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: GenderToggle(
                      selectedGender: viewModel.selectedGender,
                      onSelectedButton: (gender) {
                        viewModel.changeGender(gender);
                      },
                    ),
                  ),
                ],
              );
            }),
      ),

    );
  }
}