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
