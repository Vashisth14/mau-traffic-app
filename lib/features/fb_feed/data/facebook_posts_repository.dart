import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/api_client.dart';
import '../domain/facebook_post.dart';

// >>>>>>>>>>>>  FILL THESE WITH YOUR REAL VALUES  <<<<<<<<<<<
// For now, ONLY for local testing. Do NOT commit to GitHub.
const String fbPageId = '965643846639631';         // your page ID
const String fbPageAccessToken = 'EAAURrKJSGv8BQZBfYxEipaX6WXxKizhCOEmpzSJvlEQpOp3B5pLd6g8pvFeZAyHneM7Vk5KZBqEZBDWRQ0hZBrqXvDfVzuA3dEX0nJ8wLo06KHiuPQvZAZAQPYVtoZBiDJe3sbcdTGeZAFDaFHhkrC8mdvtNZBMoCCTepQeALBvvCySJhbswjtyi5kpevP93d1KrvBxroCQlY7'; // your PAGE access token

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
      '/$fbPageId/posts',
      queryParameters: {
        'fields': 'message,created_time,full_picture',
        'access_token': fbPageAccessToken,
      },
      options: Options(responseType: ResponseType.json),
    );

    // ✅ Android sometimes returns a String, web returns a Map
    final dynamic raw = response.data;

    final Map<String, dynamic> jsonMap = raw is String
        ? jsonDecode(raw) as Map<String, dynamic>
        : Map<String, dynamic>.from(raw as Map);

    final List<dynamic> dataList = (jsonMap['data'] as List<dynamic>? ?? []);

    return dataList
        .map((e) => FacebookPost.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}