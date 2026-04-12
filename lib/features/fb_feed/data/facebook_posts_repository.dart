import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_client.dart';
import '../domain/feed_post.dart';

final facebookPostsRepositoryProvider =
    Provider<FacebookPostsRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return FacebookPostsRepository(dio);
});

class FacebookPostsRepository {
  final Dio _dio;

  FacebookPostsRepository(this._dio);

  Future<List<FeedPost>> fetchPosts() async {
    final response = await _dio.get(
      '/social-posts',
      options: Options(responseType: ResponseType.json),
    );

    final dynamic raw = response.data;

    final List<dynamic> dataList = raw is String
        ? jsonDecode(raw)
        : List<dynamic>.from(raw);

    return dataList.map((e) {
      final map = Map<String, dynamic>.from(e);

      return FeedPost.fromJson(map);
    }).toList();
  }
}