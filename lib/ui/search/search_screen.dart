import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:look_talk/core/extension/text_style_extension.dart';
import 'package:look_talk/model/entity/post_entity.dart';
import 'package:look_talk/model/entity/response/post_response.dart';
import 'package:look_talk/model/repository/search_repository.dart';
import 'package:look_talk/ui/common/const/gap.dart';
import 'package:look_talk/view_model/search_view_model.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../common/component/community/post_item.dart';
import '../common/component/community/post_list.dart';

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
    timeago.setLocaleMessages('ko', timeago.KoMessages());

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
                    final viewModel = Provider.of<SearchViewModel>(
                      context,
                      listen: false,
                    );
                    viewModel.search(value);
                  },
                );
              },
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
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
                    final question = viewModel.questionCommunities.isNotEmpty
                        ? viewModel.questionCommunities
                        : null;
                    print(
                      "viewModel.questionCommunities.length${viewModel.questionCommunities.length}",
                    );
                    final recommend = viewModel.recommendCommunities.isNotEmpty
                        ? viewModel.recommendCommunities
                        : null;
                    print(
                      "viewModel.recommendCommunities.length${viewModel.recommendCommunities.length}",
                    );
                    return TabBarView(
                      children: [
                        viewModel.products.isEmpty
                            ? Center(child: Text("찾으시는 제품이 없습니다."))
                            : GridView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 2, vertical: 16),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      childAspectRatio: 0.6,
                                    ),
                                itemCount: viewModel.products.length,
                                itemBuilder: (context, index) {
                                  final product = viewModel.products[index];
                                  final imageUrl = product.thumbnailImage;
                                  final isValidImage =
                                      imageUrl != null &&
                                      imageUrl.trim().isNotEmpty;

                                  return GestureDetector(
                                    onTap: () {
                                      if (product.id != null) {
                                        context.push('/product/${product.id}');
                                      }
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        isValidImage
                                            ? Image.network(
                                                imageUrl!,
                                                width: 100,
                                                height: 103,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) => Icon(
                                                      Icons.broken_image,
                                                      size: 100,
                                                      color: Colors.grey,
                                                    ),
                                              )
                                            : Icon(
                                                Icons.image,
                                                size: 100,
                                                color: Colors.grey,
                                              ),

                                        gap8,
                                        Text(
                                          product.storeName ?? '',
                                          style: context.h1.copyWith(
                                            fontSize: 12,
                                          ),
                                        ),
                                        gap4,
                                        Text(
                                          product.name,
                                          style: context.bodyBold.copyWith(
                                            fontSize: 10,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            if (product.discount != null) ...[
                                              // if (product.discount?.isActive == true) ...[
                                              Text(
                                                "${product.discount!.value}% ",
                                                style: context.bodyBold
                                                    .copyWith(
                                                      fontSize: 12,
                                                      color: Colors.red,
                                                    ),
                                              ),
                                              gapW4,
                                              Text(
                                                "${(product.price * (100 - product.discount!.value) ~/ 100)}원",
                                                style: context.h1.copyWith(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ] else ...[
                                              Text(
                                                "${product.price}원",
                                                style: context.h1.copyWith(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                        viewModel.communities.isEmpty
                            ? Center(child: Text("찾으시는 커뮤니티 글이 없습니다."))
                            : SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 30),
                                          child: GestureDetector(
                                            onTap: () {
                                              context.push(
                                                '/searchCommunityDetail',
                                                extra: {
                                                  'viewModel': viewModel,
                                                  'category': 'coord_question',
                                                },
                                              );
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '코디 질문',
                                                    style: context.bodyBold
                                                        .copyWith(
                                                          fontSize: 18.0,
                                                        ),
                                                  ),
                                                  Icon(Icons.chevron_right),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        gap8,
                                        GestureDetector(
                                          onTap: () {
                                            context.push(
                                              '/post/${viewModel.communities[0].id}',
                                            );
                                          },
                                          child: (question != null)
                                              ? PostItem(post: question.first)
                                              : const SizedBox.shrink(),
                                        ),
                                      ],
                                    ),
                                    gap16,
                                    Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: 30),
                                          child: GestureDetector(
                                            onTap: () {
                                              context.push(
                                                '/searchCommunityDetail',
                                                extra: {
                                                  'viewModel': viewModel,
                                                  'category': 'coord_recommend',
                                                },
                                              );
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '코디 추천',
                                                    style: context.bodyBold
                                                        .copyWith(
                                                          fontSize: 18.0,
                                                        ),
                                                  ),
                                                  Icon(Icons.chevron_right),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        gap8,
                                        GestureDetector(
                                          onTap: () {
                                            context.push(
                                              '/post/${viewModel.questionCommunities[0].id}',
                                            );
                                          },
                                          child: (recommend != null)
                                              ? PostItem(post: recommend.first)
                                              : const SizedBox.shrink(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget communityCard({
    required String nickname,
    required String title,
    required String timeAgo,
    String? thumbnailUrl,
    required int likes,
    int comments = 0,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                    gapW8,
                    Text(nickname, style: context.bodyBold),
                  ],
                ),
                gap8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      title,
                      style: context.bodyBold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (thumbnailUrl?.isNotEmpty == true)
                      Image.network(
                        thumbnailUrl!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.image, size: 60, color: Colors.grey),
                      ),
                  ],
                ),
                gap16,
                Row(
                  children: [
                    gapW8,
                    Icon(Icons.favorite_border),
                    gapW8,
                    Text("${likes}", style: context.caption),
                    gapW8,
                    Icon(Icons.mode_comment_outlined),
                    gapW8,
                    Text('${comments}', style: context.caption),

                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Text(timeAgo),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
