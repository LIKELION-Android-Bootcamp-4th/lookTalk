import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            height: 50,
            child: TextField(
              decoration: InputDecoration(
                    hintText: "검색어를 입력해주세요",
                    suffixIcon: Icon(Icons.close),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black87, width: 0.5),
                    )
              ),
            ),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Column(
          children: [
            TabBar(
              indicatorWeight: 0.2,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
              tabs: [
                Tab(text: "제품 검색"),
                Tab(text: "커뮤니티 검색"),
              ],
            ),
            Expanded(
                child: TabBarView(children: [
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
                  ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: 8,
                    itemBuilder: (context,index){
                      return Container(
                        height: 80,
                        margin: EdgeInsets.only(bottom: 8),
                        color: Colors.grey[300],
                      );
                    },
                  )
                ]),
            )
          ],
        ),
      ),

    );
  }
}