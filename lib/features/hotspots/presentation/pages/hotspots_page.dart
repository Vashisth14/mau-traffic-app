import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HotspotsPage extends StatelessWidget {
  const HotspotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hotspots = [
      const HotspotItem(
        area: 'Terre Rouge',
        road: 'M2 Link Road',
        incidents: 6,
        level: 'High',
        color: Color(0xFFD62828),
        icon: Icons.warning_amber_rounded,
      ),
      const HotspotItem(
        area: 'Port Louis',
        road: 'Motorway M1',
        incidents: 4,
        level: 'Moderate',
        color: Color(0xFFF77F00),
        icon: Icons.traffic,
      ),
      const HotspotItem(
        area: 'Rose Hill',
        road: 'Royal Road',
        incidents: 3,
        level: 'Moderate',
        color: Color(0xFFF4B400),
        icon: Icons.alt_route_rounded,
      ),
      const HotspotItem(
        area: 'Curepipe',
        road: 'Central Junction',
        incidents: 2,
        level: 'Low',
        color: Color(0xFF16A34A),
        icon: Icons.location_on_rounded,
      ),
    ];

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
          child: CustomScrollView(
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
                          const SizedBox(width: 48),
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
                              'This page highlights major hotspots based on incident posts collected by the system.',
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
                    const _MapPreviewCard(),
                    const SizedBox(height: 22),
                    const _SectionTitle(
                      title: 'Today\'s Summary',
                      icon: Icons.analytics_rounded,
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: '12',
                            subtitle: 'Incidents',
                            color: Color(0xFFD62828),
                            icon: Icons.warning_amber_rounded,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: '4',
                            subtitle: 'Hotspots',
                            color: Color(0xFF0A84C6),
                            icon: Icons.location_on_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: '3',
                            subtitle: 'High Risk',
                            color: Color(0xFFF77F00),
                            icon: Icons.report_problem_rounded,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Live',
                            subtitle: 'Monitoring',
                            color: Color(0xFF16A34A),
                            icon: Icons.radar_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const _SectionTitle(
                      title: 'Top Accident Hotspots',
                      icon: Icons.local_fire_department_rounded,
                    ),
                    const SizedBox(height: 12),
                    ...hotspots.map((item) => _HotspotCard(item: item)),
                  ]),
                ),
              ),
            ],
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

  const HotspotItem({
    required this.area,
    required this.road,
    required this.incidents,
    required this.level,
    required this.color,
    required this.icon,
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
  const _MapPreviewCard();

  @override
  State<_MapPreviewCard> createState() => _MapPreviewCardState();
}

class _MapPreviewCardState extends State<_MapPreviewCard> {
  GoogleMapController? _mapController;

  static const LatLng _mauritiusCenter = LatLng(-20.348404, 57.552152);

  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('port-louis'),
      position: LatLng(-20.1609, 57.5012),
      infoWindow: InfoWindow(title: 'Port Louis'),
    ),
    Marker(
      markerId: MarkerId('terre-rouge'),
      position: LatLng(-20.1239, 57.5242),
      infoWindow: InfoWindow(title: 'Terre Rouge'),
    ),
    Marker(
      markerId: MarkerId('rose-hill'),
      position: LatLng(-20.2336, 57.4719),
      infoWindow: InfoWindow(title: 'Rose Hill'),
    ),
    Marker(
      markerId: MarkerId('curepipe'),
      position: LatLng(-20.3162, 57.5256),
      infoWindow: InfoWindow(title: 'Curepipe'),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      elevation: 4,
      child: SizedBox(
        height: 260,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _mauritiusCenter,
              zoom: 10.8,
            ),
            markers: _markers,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
        ),
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final String label;
  final Color color;

  const _MapPin({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.location_on_rounded,
          color: color,
          size: 28,
        ),
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
      ],
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
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
                    item.road,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _MiniBadge(
                        text: '${item.incidents} incidents',
                        color: item.color,
                      ),
                      const SizedBox(width: 8),
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

class _GridPainter extends CustomPainter {
  const _GridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2563EB).withValues(alpha: 0.18)
      ..strokeWidth = 1;

    const spacing = 28.0;

    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}