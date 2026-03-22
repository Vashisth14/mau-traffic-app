import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_client.dart';
import '../domain/facebook_post.dart';

final facebookPostsRepositoryProvider =
    Provider<FacebookPostsRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return FacebookPostsRepository(dio);
});

class FacebookPostsRepository {
  final Dio _dio;

  FacebookPostsRepository(this._dio);

  Future<List<FacebookPost>> fetchPosts() async {
    final response = await _dio.get(
      '/social-posts',
      options: Options(responseType: ResponseType.json),
    );

    final dynamic raw = response.data;

    final List<dynamic> dataList = raw is String
        ? jsonDecode(raw) as List<dynamic>
        : List<dynamic>.from(raw as List);

    return dataList.map((e) {
      final map = Map<String, dynamic>.from(e as Map);

      return FacebookPost(
        id: map['_id']?.toString() ?? '',
        message: map['message'] ?? '',
        createdTime: DateTime.parse(map['createdTime']),
        fullPicture: map['imageUrl'],
      );
    }).toList();
  }
}