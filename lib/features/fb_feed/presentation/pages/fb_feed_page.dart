import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fb_feed_controller.dart';
import '../../domain/facebook_post.dart';

class FbFeedPage extends ConsumerWidget {
  const FbFeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(fbPostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Facebook Accident Feed'),
      ),
      body: postsAsync.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(
              child: Text('No posts found on your page.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final p = posts[index];
              return _PostCard(post: p);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Error: $e'),
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final FacebookPost post;

  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Time: ${post.createdTime}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (post.fullPicture != null) ...[
              const SizedBox(height: 8),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  post.fullPicture!,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}