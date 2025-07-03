import 'package:flutter/material.dart';
import 'package:look_talk/ui/common/component/app_bar/app_bar_search_cart.dart';
import 'package:look_talk/ui/main/home/home_category.dart';
import 'package:look_talk/view_model/home/home_category_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:  (_)=>HomeCategoryViewModel())
      ],
      child:  Scaffold(
        appBar: AppBarSearchCart(leading: Image.asset('assets/images/logo.png',)),

        body: Column(
          children: [
            HomeCategory(),
            Expanded(
                child:
                GridView.builder(
                  padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index){
                    return Container(
                      color: Colors.grey[300],
                      height: 100,
                    );
                  },

                ),
            )



          ],
        ),
      ),
    );
  }
}