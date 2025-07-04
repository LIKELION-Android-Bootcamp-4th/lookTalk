import 'dart:convert';
import 'package:http/http.dart' as http;

import '../entity/post_entity.dart';

class PostRepository {
  Future<List<Post>> fetchPosts(String category) async {
    final response = await http.get(
      Uri.parse('https://your.api/posts?category=$category'), // TODO: 수정
    );

    if (response.statusCode == 200) {
      final List<dynamic> items = jsonDecode(response.body)['data']['items'];

      return items.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('게시글 불러오기 실패');
    }
  }
}

