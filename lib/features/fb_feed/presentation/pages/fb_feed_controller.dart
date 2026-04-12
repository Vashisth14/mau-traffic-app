import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/facebook_posts_repository.dart';
import '../../domain/feed_post.dart';

final fbPostsProvider = FutureProvider<List<FeedPost>>((ref) async {
  final repo = ref.watch(facebookPostsRepositoryProvider);
  return repo.fetchPosts();
});