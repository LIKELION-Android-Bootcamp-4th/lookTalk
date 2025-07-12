import 'package:look_talk/model/entity/response/post_response.dart';

import '../pagination_entity.dart';

// class PostListResponse {
//   final List<PostResponse> items;
//   final Pagination pagination;
//
//   PostListResponse({
//     required this.items,
//     required this.pagination,
//   });
//
//   factory PostListResponse.fromJson(Map<String, dynamic> json) {
//     final data = json['data'] ?? {};
//
//     final itemsJson = (data['items'] as List<dynamic>? ?? []);
//
//     return PostListResponse(
//       items: itemsJson
//           .whereType<Map<String, dynamic>>()
//           .map((item) => PostResponse.fromJson(item))
//           .toList(),
//       pagination: Pagination.fromJson(
//         data['pagination'] is Map<String, dynamic> ? data['pagination'] : {},
//       ),
//     );
//   }
// }

class PostListResponse {
  final List<PostResponse> items;
  final Pagination pagination;

  PostListResponse({
    required this.items,
    required this.pagination,
  });

  // factory PostListResponse.fromJson(Map<String, dynamic> json) {
  //   final data = json['data'] ?? {};
  //
  //   final itemsJson = (data['items'] as List<dynamic>? ?? [])
  //       .whereType<Map<String, dynamic>>()
  //       .toList();
  //
  //   final paginationJson = data['pagination'];
  //   final pagination = paginationJson is Map<String, dynamic>
  //       ? Pagination.fromJson(paginationJson)
  //       : Pagination.fromJson({});
  //
  //   return PostListResponse(
  //     items: itemsJson.map((item) => PostResponse.fromJson(item)).toList(),
  //     pagination: pagination,
  //   );
  // }
  // factory PostListResponse.fromJson(Map<String, dynamic> json) {
  //   final data = json['data'] ?? {};
  //   final rawItems = data['items'];
  //
  //   final items = <PostResponse>[];
  //
  //   if (rawItems is List) {
  //     for (final item in rawItems) {
  //       if (item is Map<String, dynamic>) {
  //         print("PostResponse.fromJson 호출됨: ${item['title']}");
  //         items.add(PostResponse.fromJson(item));
  //       } else {
  //         print("❗item 타입이 Map<String, dynamic>이 아님: $item");
  //       }
  //     }
  //   } else {
  //     print("❗data['items']가 List가 아님: $rawItems");
  //   }
  //
  //   final paginationJson = data['pagination'];
  //   final pagination = paginationJson is Map<String, dynamic>
  //       ? Pagination.fromJson(paginationJson)
  //       : Pagination(page: 0, limit: 0, total: 0, totalPages: 0, hasNext: false, hasPrev: false);
  //
  //   return PostListResponse(
  //     items: items,
  //     pagination: pagination,
  //   );
  // }

  factory PostListResponse.fromJson(Object? json) {
    final map = json as Map<String, dynamic>? ?? {};
    final itemsJson = map['items'] is List ? map['items'] as List : [];

    return PostListResponse(
      items: itemsJson
          .whereType<Map<String, dynamic>>()
          .map((item) => PostResponse.fromJson(item))
          .toList(),
      pagination: Pagination.fromJson(
        map['pagination'] is Map<String, dynamic> ? map['pagination'] : {},
      ),
    );
  }




}
