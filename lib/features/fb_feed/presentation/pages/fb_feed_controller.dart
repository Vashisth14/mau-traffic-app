import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/facebook_posts_repository.dart';
import '../../domain/facebook_post.dart';

final fbPostsProvider = FutureProvider<List<FacebookPost>>((ref) async {
  final repo = ref.watch(facebookPostsRepositoryProvider);
  return repo.fetchPosts();
});