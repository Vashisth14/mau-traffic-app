import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../pages/fb_feed_controller.dart';
import '../../domain/feed_post.dart';

class FbFeedPage extends ConsumerWidget {
  const FbFeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(fbPostsProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF7F9FC),
              Color(0xFFEAF4FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(fbPostsProvider);
              await ref.read(fbPostsProvider.future);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: _FeedHeader()),
                postsAsync.when(
                  data: (posts) {
                    if (posts.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 420,
                          child: Center(child: _EmptyFeedState()),
                        ),
                      );
                    }

                    final sortedPosts = [...posts]
                      ..sort((a, b) => b.createdTime.compareTo(a.createdTime));

                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final post = sortedPosts[index];
                            return _FeedPostCard(post: post);
                          },
                          childCount: sortedPosts.length,
                        ),
                      ),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 400,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  error: (e, _) => SliverToBoxAdapter(
                    child: SizedBox(
                      height: 420,
                      child: Center(
                        child: _ErrorFeedState(
                          message: e.toString(),
                          onRetry: () {
                            ref.invalidate(fbPostsProvider);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedHeader extends ConsumerWidget {
  const _FeedHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
              const Expanded(
                child: Text(
                  'Live Accident Feed',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  ref.invalidate(fbPostsProvider);
                },
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0057B8),
                  Color(0xFF0A84C6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0057B8).withValues(alpha: 0.18),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.dynamic_feed_rounded, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Mauritius Traffic Alerts',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  'Track road incidents reported across Mauritius in real time.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.35,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Pull down to refresh the latest updates from the system feed.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.5,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedPostCard extends StatelessWidget {
  final FeedPost post;

  const _FeedPostCard({required this.post});

  String _formatTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy • hh:mm a').format(dateTime.toLocal());
  }

  Color _sourceColor() {
    return post.source.toLowerCase() == 'app'
        ? const Color(0xFF16A34A)
        : const Color(0xFF0057B8);
  }

  String _sourceLabel() {
    return post.source.toLowerCase() == 'app' ? 'App Report' : 'Facebook Feed';
  }

  Color _severityColor(String? value) {
    switch ((value ?? '').toLowerCase()) {
      case 'high':
      case 'severe':
        return const Color(0xFFD62828);
      case 'medium':
      case 'moderate':
        return const Color(0xFFF77F00);
      case 'low':
        return const Color(0xFF16A34A);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  IconData _severityIcon(String? value) {
    switch ((value ?? '').toLowerCase()) {
      case 'high':
      case 'severe':
        return Icons.priority_high_rounded;
      case 'medium':
      case 'moderate':
        return Icons.warning_amber_rounded;
      case 'low':
        return Icons.info_outline_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String _severityLabel(String? value) {
    final text = (value ?? 'unknown').trim();
    if (text.isEmpty) return 'Unknown';
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  String _confidencePercent(double value) {
    return '${(value * 100).toStringAsFixed(0)}%';
  }

  String _confidenceLevel(double value) {
    if (value >= 0.8) return 'High';
    if (value >= 0.6) return 'Medium';
    return 'Low';
  }

  Color _confidenceColor(double value) {
    if (value >= 0.8) return const Color(0xFF0057B8);
    if (value >= 0.6) return const Color(0xFFF77F00);
    return const Color(0xFF64748B);
  }

  String _smartSummary() {
    final summary = (post.nlpSummary ?? '').trim();
    if (summary.isNotEmpty) return summary;
    return post.isAccidentRelated
        ? 'Road accident-related content detected by the AI layer.'
        : 'This post does not appear to describe a traffic accident.';
  }

  @override
  Widget build(BuildContext context) {
    final message = post.message.trim().isEmpty
        ? 'No caption available for this incident.'
        : post.message.trim();

    final sourceColor = _sourceColor();
    final sourceLabel = _sourceLabel();
    final severityColor = _severityColor(post.severity);
    final confidenceColor = _confidenceColor(post.confidence);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: severityColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _TopBadge(
                      text: post.isAccidentRelated
                          ? 'Accident Alert'
                          : 'Traffic Update',
                      icon: post.isAccidentRelated
                          ? Icons.warning_amber_rounded
                          : Icons.traffic_rounded,
                      background: post.isAccidentRelated
                          ? const Color(0xFFFFEFEF)
                          : const Color(0xFFEAF4FF),
                      foreground: post.isAccidentRelated
                          ? const Color(0xFFD62828)
                          : const Color(0xFF0057B8),
                    ),
                    const Spacer(),
                    _TopBadge(
                      text: sourceLabel,
                      background: sourceColor.withValues(alpha: 0.10),
                      foreground: sourceColor,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                    height: 1.42,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _smartSummary(),
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF475569),
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MiniInfoChip(
                      text: post.isAccidentRelated
                          ? 'Accident-related'
                          : 'Not accident-related',
                      backgroundColor: post.isAccidentRelated
                          ? const Color(0xFFFFEAEA)
                          : const Color(0xFFE8F7EE),
                      textColor: post.isAccidentRelated
                          ? const Color(0xFFD62828)
                          : const Color(0xFF15803D),
                    ),
                    _MiniInfoChip(
                      text:
                          'Confidence ${_confidenceLevel(post.confidence)} (${_confidencePercent(post.confidence)})',
                      backgroundColor: confidenceColor.withValues(alpha: 0.12),
                      textColor: confidenceColor,
                    ),
                    _MiniInfoChip(
                      text: 'Severity ${_severityLabel(post.severity)}',
                      icon: _severityIcon(post.severity),
                      backgroundColor: severityColor.withValues(alpha: 0.12),
                      textColor: severityColor,
                    ),
                    if (post.possibleLocations.isNotEmpty)
                      _MiniInfoChip(
                        text: post.possibleLocations.first,
                        icon: Icons.place_outlined,
                        backgroundColor: const Color(0xFFFFF3E8),
                        textColor: const Color(0xFFB45309),
                      ),
                  ],
                ),
                if (post.source.toLowerCase() == 'app') ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (post.location != null && post.location!.trim().isNotEmpty)
                        _MiniInfoChip(
                          text: post.location!,
                          icon: Icons.place_outlined,
                          backgroundColor: const Color(0xFFEEF6FF),
                          textColor: const Color(0xFF0057B8),
                        ),
                      if (post.road != null && post.road!.trim().isNotEmpty)
                        _MiniInfoChip(
                          text: post.road!,
                          icon: Icons.alt_route_rounded,
                          backgroundColor: const Color(0xFFF8FAFC),
                          textColor: const Color(0xFF475569),
                        ),
                      if (post.vehicleType != null &&
                          post.vehicleType!.trim().isNotEmpty)
                        _MiniInfoChip(
                          text: post.vehicleType!,
                          icon: Icons.directions_car_filled_outlined,
                          backgroundColor: const Color(0xFFF8FAFC),
                          textColor: const Color(0xFF475569),
                        ),
                      if (post.injuryReported)
                        const _MiniInfoChip(
                          text: 'Injury reported',
                          icon: Icons.medical_services_outlined,
                          backgroundColor: Color(0xFFFFEAEA),
                          textColor: Color(0xFFD62828),
                        ),
                      if (post.roadBlocked)
                        const _MiniInfoChip(
                          text: 'Road blocked',
                          icon: Icons.block_outlined,
                          backgroundColor: Color(0xFFFFF3E8),
                          textColor: Color(0xFFF77F00),
                        ),
                    ],
                  ),
                ],
                if (post.possibleLocations.length > 1) ...[
                  const SizedBox(height: 14),
                  const Text(
                    'Detected locations',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: post.possibleLocations
                        .skip(1)
                        .map(
                          (place) => _MiniInfoChip(
                            text: place,
                            backgroundColor: const Color(0xFFFFF3E8),
                            textColor: const Color(0xFFB45309),
                          ),
                        )
                        .toList(),
                  ),
                ],
                if (post.keywords.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  const Text(
                    'Keywords',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF475569),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: post.keywords
                        .take(6)
                        .map(
                          (keyword) => _MiniInfoChip(
                            text: keyword,
                            backgroundColor: const Color(0xFFF1F5F9),
                            textColor: const Color(0xFF475569),
                          ),
                        )
                        .toList(),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _formatTime(post.createdTime),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                if (post.fullPicture != null &&
                    post.fullPicture!.trim().isNotEmpty) ...[
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: AspectRatio(
                      aspectRatio: 16 / 10,
                      child: Image.network(
                        post.fullPicture!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFFE2E8F0),
                            alignment: Alignment.center,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image_outlined,
                                  size: 34,
                                  color: Colors.black45,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Unable to load image',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          );
                        },
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: const Color(0xFFEAF4FF),
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBadge extends StatelessWidget {
  final String text;
  final Color background;
  final Color foreground;
  final IconData? icon;

  const _TopBadge({
    required this.text,
    required this.background,
    required this.foreground,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: foreground),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: TextStyle(
              color: foreground,
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniInfoChip extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const _MiniInfoChip({
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFEAF4FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: textColor ?? const Color(0xFF1E293B),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: textColor ?? const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyFeedState extends StatelessWidget {
  const _EmptyFeedState();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 88,
            width: 88,
            decoration: BoxDecoration(
              color: const Color(0xFF0057B8).withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.dynamic_feed_rounded,
              size: 42,
              color: Color(0xFF0057B8),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No alerts available',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'There are currently no synced traffic incidents to display. Pull down to refresh once new data is available.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              height: 1.5,
              fontSize: 14.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorFeedState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorFeedState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(26),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 88,
            width: 88,
            decoration: BoxDecoration(
              color: const Color(0xFFD62828).withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              size: 42,
              color: Color(0xFFD62828),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Unable to load feed',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: const TextStyle(
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}