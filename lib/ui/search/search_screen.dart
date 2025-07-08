import 'package:flutter/material.dart';
import 'package:look_talk/model/repository/search_repository.dart';
import 'package:look_talk/view_model/search_view_model.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Container(
              height: 50,
              child: Builder(
                builder: (context) {
                  return TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "검색어를 입력해주세요",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          controller.clear();
                        },
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black87, width: 0.5),
                      ),
                    ),
                    onSubmitted: (value) {
                      final viewModel = Provider.of<SearchViewModel>(context, listen: false);
                      viewModel.search(value);
                    },
                  );
                },
              ),
            ),
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
                child: Consumer<SearchViewModel>(
                  builder: (context, viewModel, _) {
                    return TabBarView(
                      children: [
                        viewModel.products.isEmpty
                            ? Center(child: Text("찾으시는 제품이 없습니다."))
                            : GridView.builder(
                          padding: EdgeInsets.all(8),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                          itemCount: viewModel.products.length,
                          itemBuilder: (context, index) {
                            final product = viewModel.products[index];
                            final imageUrl = product.images.isNotEmpty ? product.images.first : null;

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  imageUrl != null
                                      ? Image.network(
                                    imageUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  )
                                      : Icon(Icons.image, size: 80, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4),
                                  Text("${product.price}원"),
                                ],
                              ),
                            );
                          },
                        ),
                        viewModel.communities.isEmpty
                            ? Center(child: Text("찾으시는 커뮤니티 글이 없습니다."))
                            : ListView.builder(
                          padding: EdgeInsets.all(8),
                          itemCount: viewModel.communities.length,
                          itemBuilder: (context, index) {
                            final community = viewModel.communities[index];
                            return Container(
                              padding: EdgeInsets.all(12),
                              margin: EdgeInsets.only(bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(community.title, style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.visibility, size: 16),
                                      SizedBox(width: 4),
                                      Text("${community.viewCount}"),
                                      SizedBox(width: 16),
                                      Icon(Icons.favorite, size: 16),
                                      SizedBox(width: 4),
                                      Text("${community.likeCount}"),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
  }
}
