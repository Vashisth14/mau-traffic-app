import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../fb_feed/presentation/pages/fb_feed_controller.dart';
import '../../../fb_feed/domain/feed_post.dart';

class HotspotsPage extends ConsumerWidget {
  const HotspotsPage({super.key});

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
          child: postsAsync.when(
            data: (posts) {
              final now = DateTime.now();

              bool isToday(DateTime date) {
                final local = date.toLocal();
                return local.year == now.year &&
                    local.month == now.month &&
                    local.day == now.day;
              }

              final todayAccidentPosts = posts
                  .where((p) => p.isAccidentRelated && isToday(p.createdTime))
                  .toList();

              final recentPosts = posts.where((p) {
                final local = p.createdTime.toLocal();
                return p.isAccidentRelated &&
                    now.difference(local).inDays <= 7;
              }).toList();

              final hotspotItems = _buildHotspotsFromPosts(recentPosts);
              final markers = _buildMarkers(hotspotItems);

              final totalIncidents = todayAccidentPosts.length;
              final totalHotspots = hotspotItems.length;
              final highRiskCount = hotspotItems
                  .where((e) => e.level.toLowerCase() == 'high')
                  .length;

              final latestPost = posts.isNotEmpty
                  ? posts.reduce(
                      (a, b) => a.createdTime.isAfter(b.createdTime) ? a : b,
                    )
                  : null;

              final latestUpdate = latestPost != null
                  ? DateFormat('hh:mm a').format(latestPost.createdTime.toLocal())
                  : '--';

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(fbPostsProvider);
                  await ref.read(fbPostsProvider.future);
                },
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
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
                                    'Hotspots & Map',
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
                                    color: const Color(0xFF0057B8)
                                        .withValues(alpha: 0.18),
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
                                      Icon(Icons.public, color: Colors.white),
                                      SizedBox(width: 8),
                                      Text(
                                        'Mauritius Road Monitoring',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Visualise accident-prone areas and traffic risk zones across Mauritius.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      height: 1.35,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'The map below is generated from AI-detected locations extracted from recent accident-related reports.',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13.5,
                                      height: 1.45,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Based on accident-related incidents detected in the last 7 days.',
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
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          const _SectionTitle(
                            title: 'Mauritius Overview Map',
                            icon: Icons.map_rounded,
                          ),
                          const SizedBox(height: 12),
                          _MapPreviewCard(markers: markers),
                          const SizedBox(height: 22),
                          const _SectionTitle(
                            title: 'Today\'s Summary',
                            icon: Icons.analytics_rounded,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  title: '$totalIncidents',
                                  subtitle: 'Incidents Today',
                                  color: const Color(0xFFD62828),
                                  icon: Icons.warning_amber_rounded,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _StatCard(
                                  title: '$totalHotspots',
                                  subtitle: 'Hotspots',
                                  color: const Color(0xFF0A84C6),
                                  icon: Icons.location_on_rounded,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  title: '$highRiskCount',
                                  subtitle: 'High Risk',
                                  color: const Color(0xFFF77F00),
                                  icon: Icons.report_problem_rounded,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _StatCard(
                                  title: latestUpdate,
                                  subtitle: 'Latest Update',
                                  color: const Color(0xFF16A34A),
                                  icon: Icons.access_time_rounded,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          const _SectionTitle(
                            title: 'Detected Accident Hotspots',
                            icon: Icons.local_fire_department_rounded,
                          ),
                          const SizedBox(height: 12),
                          if (hotspotItems.isEmpty)
                            const _EmptyHotspotsCard()
                          else
                            ...hotspotItems.map((item) => _HotspotCard(item: item)),
                        ]),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (e, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 46,
                      color: Color(0xFFD62828),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Unable to load hotspot data',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      e.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HotspotItem {
  final String area;
  final String road;
  final int incidents;
  final String level;
  final Color color;
  final IconData icon;
  final LatLng position;
  final DateTime lastDetected;

  const HotspotItem({
    required this.area,
    required this.road,
    required this.incidents,
    required this.level,
    required this.color,
    required this.icon,
    required this.position,
    required this.lastDetected,
  });
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF0057B8).withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF0057B8)),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}

class _MapPreviewCard extends StatefulWidget {
  final Set<Marker> markers;

  const _MapPreviewCard({
    required this.markers,
  });

  @override
  State<_MapPreviewCard> createState() => _MapPreviewCardState();
}

class _MapPreviewCardState extends State<_MapPreviewCard> {
  GoogleMapController? _mapController;

  static const LatLng _mauritiusCenter = LatLng(-20.2440, 57.4970);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 4,
      shadowColor: Colors.black12,
      child: SizedBox(
        height: 260,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _mauritiusCenter,
              zoom: 11.2,
            ),
            markers: widget.markers,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            mapType: MapType.normal,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      elevation: 3,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        child: Column(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HotspotCard extends StatelessWidget {
  final HotspotItem item;

  const _HotspotCard({
    required this.item,
  });

  String _formatLastDetected(DateTime value) {
    return DateFormat('dd MMM • hh:mm a').format(value.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 4,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              height: 58,
              width: 58,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                item.icon,
                color: item.color,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.area,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Last detected: ${_formatLastDetected(item.lastDetected)}',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MiniBadge(
                        text: '${item.incidents} incidents',
                        color: item.color,
                      ),
                      _MiniBadge(
                        text: item.level,
                        color: item.color,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _MiniBadge({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _EmptyHotspotsCard extends StatelessWidget {
  const _EmptyHotspotsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'No accident hotspots were detected in the last 7 days.',
          style: TextStyle(
            color: Colors.black54,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

List<HotspotItem> _buildHotspotsFromPosts(List<FeedPost> posts) {
  final Map<String, int> locationCounts = {};
  final Map<String, DateTime> lastDetectedMap = {};

  for (final post in posts) {
    if (!post.isAccidentRelated) continue;

    for (final location in post.possibleLocations) {
      final mappedKey = mapLocationAlias(location);
      if (!_locationCoordinates.containsKey(mappedKey)) continue;

      locationCounts[mappedKey] = (locationCounts[mappedKey] ?? 0) + 1;

      final currentLast = lastDetectedMap[mappedKey];
      if (currentLast == null || post.createdTime.isAfter(currentLast)) {
        lastDetectedMap[mappedKey] = post.createdTime;
      }
    }
  }

  final entries = locationCounts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  return entries.map((entry) {
    final incidents = entry.value;
    final level = incidents >= 3
        ? 'High'
        : incidents == 2
            ? 'Moderate'
            : 'Low';

    final color = incidents >= 3
        ? const Color(0xFFD62828)
        : incidents == 2
            ? const Color(0xFFF77F00)
            : const Color(0xFF16A34A);

    final icon = incidents >= 3
        ? Icons.warning_amber_rounded
        : incidents == 2
            ? Icons.traffic
            : Icons.location_on_rounded;

    return HotspotItem(
      area: prettyLocationName(entry.key),
      road: 'Identified from recent incident reports',
      incidents: incidents,
      level: level,
      color: color,
      icon: icon,
      position: _locationCoordinates[entry.key]!,
      lastDetected: lastDetectedMap[entry.key] ?? DateTime.now(),
    );
  }).toList();
}

Set<Marker> _buildMarkers(List<HotspotItem> items) {
  return items.map((item) {
    return Marker(
      markerId: MarkerId(item.area),
      position: item.position,
      infoWindow: InfoWindow(
        title: item.area,
        snippet: '${item.incidents} incident(s) • ${item.level} risk',
      ),
    );
  }).toSet();
}

String normalizeLocationKey(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll("’", "'")
      .replaceAll(RegExp(r'\s+'), ' ');
}

String mapLocationAlias(String value) {
  final normalized = normalizeLocationKey(value);

  const aliases = {
    'highlands roundabout': 'highlands',
    'highlands': 'highlands',
    'st pierre': 'st pierre',
    'saint pierre': 'st pierre',
    'l esperance': "l'esperance",
    'l\'esperance': "l'esperance",
    'beau bassin': 'beau bassin',
    'quatre bornes': 'quatre bornes',
    'rose hill': 'rose hill',
    'terre rouge': 'terre rouge',
    'camp thorel': 'camp thorel',
    'phoenix': 'phoenix',
    'vacoas': 'vacoas',
    'ebene': 'ebene',
    'reduit': 'reduit',
    'réduit': 'reduit',
    'bambous': 'bambous',
    'flacq': 'flacq',
    'moka': 'moka',
    'port louis': 'port louis',
    'mahebourg': 'mahebourg',
    'souillac': 'souillac',
    'triolet': 'triolet',
    'coromandel': 'coromandel',
    'goodlands': 'goodlands',
    'pailles': 'pailles',
    'curepipe': 'curepipe',
    'quartier militaire': 'quartier militaire',
    'rose belle': 'rose belle',
    'trianon': 'trianon',
  };

  return aliases[normalized] ?? normalized;
}

String prettyLocationName(String value) {
  return value
      .split(' ')
      .map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1);
      })
      .join(' ')
      .replaceAll("L'esperance", "L'Esperance");
}

const Map<String, LatLng> _locationCoordinates = {
  'port louis': LatLng(-20.1609, 57.5012),
  'terre rouge': LatLng(-20.1239, 57.5242),
  'rose hill': LatLng(-20.2336, 57.4719),
  'curepipe': LatLng(-20.3162, 57.5256),
  'camp thorel': LatLng(-20.3006, 57.6314),
  "l'esperance": LatLng(-20.3140, 57.6120),
  'goodlands': LatLng(-20.0350, 57.6430),
  'pailles': LatLng(-20.1928, 57.4881),
  'bambous': LatLng(-20.2567, 57.4064),
  'flacq': LatLng(-20.1911, 57.7142),
  'moka': LatLng(-20.2189, 57.4958),
  'phoenix': LatLng(-20.2834, 57.4946),
  'vacoas': LatLng(-20.2981, 57.4783),
  'quatre bornes': LatLng(-20.2654, 57.4791),
  'mahebourg': LatLng(-20.4081, 57.7000),
  'souillac': LatLng(-20.5169, 57.5166),
  'triolet': LatLng(-20.0582, 57.5502),
  'coromandel': LatLng(-20.2024, 57.4736),
  'ebene': LatLng(-20.2447, 57.4952),
  'reduit': LatLng(-20.2346, 57.4967),
  'highlands': LatLng(-20.2990, 57.5700),
  'beau bassin': LatLng(-20.2260, 57.4680),
  'st pierre': LatLng(-20.2170, 57.5210),
  'quartier militaire': LatLng(-20.2470, 57.5980),
  'rose belle': LatLng(-20.4000, 57.5960),
  'trianon': LatLng(-20.2830, 57.5000),
};