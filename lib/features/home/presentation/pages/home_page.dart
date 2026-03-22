import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TopHeader(),
              const SizedBox(height: 20),
              const _HeroBanner(),
              const SizedBox(height: 22),
              const Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.05,
                children: [
                  _ActionCard(
                    title: 'Live Feed',
                    subtitle: 'View latest incident posts',
                    icon: Icons.dynamic_feed_rounded,
                    color: const Color(0xFF0057B8),
                    onTap: () {
                      Navigator.pushNamed(context, '/fb-feed');
                    },
                  ),
                  _ActionCard(
                    title: 'Report',
                    subtitle: 'Submit an accident report',
                    icon: Icons.report_gmailerrorred_rounded,
                    color: const Color(0xFFD62828),
                    onTap: () {
                      Navigator.pushNamed(context, '/report-accident');
                    },
                  ),
                  _ActionCard(
                    title: 'Hotspots',
                    subtitle: 'Accident-prone areas',
                    icon: Icons.location_on_rounded,
                    color: const Color(0xFFF4B400),
                    onTap: () {
                          Navigator.pushNamed(context, '/hotspots');
                    },
                  ),
                  _ActionCard(
                    title: 'Alerts',
                    subtitle: 'Road updates in Mauritius',
                    icon: Icons.notifications_active_rounded,
                    color: const Color(0xFF0A84C6),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Alerts screen coming soon'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Today\'s Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              const _InfoTile(
                icon: Icons.traffic,
                title: 'Traffic Monitoring',
                subtitle: 'Track accident-related social posts in real time.',
              ),
              const _InfoTile(
                icon: Icons.public,
                title: 'Mauritian Coverage',
                subtitle: 'Designed for Port Louis, Terre Rouge, Rose Hill and beyond.',
              ),
              const _InfoTile(
                icon: Icons.smart_toy_outlined,
                title: 'AI Support',
                subtitle: 'Prepared for accident detection and location intelligence.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopHeader extends StatelessWidget {
  const _TopHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0057B8), Color(0xFF0A84C6)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.traffic,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MAU-Traffic',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Accident monitoring for Mauritian roads',
                style: TextStyle(
                  fontSize: 13.5,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF003C8F),
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
              Icon(Icons.flag_circle_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Mauritius Road Safety',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 14),
          Text(
            'Stay alert with live accident updates and smart traffic monitoring.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Powered by Facebook incident feeds, cloud storage and a mobile-first interface.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      elevation: 3,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF0057B8).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFF0057B8)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle),
        ),
      ),
    );
  }
}