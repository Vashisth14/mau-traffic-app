import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF6F8FC),
        foregroundColor: const Color(0xFF1F2937),
        centerTitle: true,
        title: const Text(
          'About MAU-Traffic',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _HeroCard(),
              const SizedBox(height: 20),

              const _SectionTitle('What is MAU-Traffic?'),
              const SizedBox(height: 10),
              const _InfoCard(
                child: Text(
                  'MAU-Traffic is a mobile application designed to support road accident monitoring in Mauritius using social media data and user-submitted reports. The system helps improve real-time awareness of incidents through live feed tracking, hotspot visualisation, and structured reporting.',
                  style: TextStyle(
                    fontSize: 14.5,
                    height: 1.6,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const _SectionTitle('Main Features'),
              const SizedBox(height: 10),

              const _FeatureTile(
                icon: Icons.dynamic_feed_rounded,
                color: Color(0xFF0057B8),
                title: 'Live Accident Feed',
                subtitle: 'View accident-related Facebook posts processed by the backend system.',
              ),
              const _FeatureTile(
                icon: Icons.report_gmailerrorred_rounded,
                color: Color(0xFFD62828),
                title: 'Accident Reporting',
                subtitle: 'Submit road accident reports with description, image, and location details.',
              ),
              const _FeatureTile(
                icon: Icons.location_on_rounded,
                color: Color(0xFFF4B400),
                title: 'Hotspot Mapping',
                subtitle: 'Visualise accident-prone areas and detected locations on an interactive map.',
              ),
              const _FeatureTile(
                icon: Icons.smart_toy_outlined,
                color: Color(0xFF0A84C6),
                title: 'AI Text Analysis',
                subtitle: 'Classify social posts, extract locations, and analyse accident-related content.',
              ),

              const SizedBox(height: 20),
              const _SectionTitle('How to Use'),
              const SizedBox(height: 10),
              const _InfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BulletText('Open Live Feed to view recent accident-related updates.'),
                    _BulletText('Use Report to submit a new accident report.'),
                    _BulletText('Visit Hotspots to explore mapped incident locations.'),
                    _BulletText('Open this page anytime for guidance about the application.'),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const _SectionTitle('Project Information'),
              const SizedBox(height: 10),
              const _InfoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoRow(
                      icon: Icons.school_outlined,
                      label: 'Project Type',
                      value: 'Research-based mobile application',
                    ),
                    SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.public_outlined,
                      label: 'Target Region',
                      value: 'Mauritius',
                    ),
                    SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.code_rounded,
                      label: 'Technology',
                      value: 'Flutter, Node.js, MongoDB',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Developed as part of a research project.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

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
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white24,
                child: Icon(
                  Icons.traffic,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'MAU-Traffic',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Smart accident monitoring for Mauritian roads.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Combining social media intelligence, user reports, and map-based visualisation to improve accident awareness.',
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

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1F2937),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;
  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FeatureTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _FeatureTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF6B7280),
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

class _BulletText extends StatelessWidget {
  final String text;
  const _BulletText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0057B8),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14.5,
                height: 1.5,
                color: Color(0xFF4B5563),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF0057B8)),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4B5563),
                height: 1.5,
              ),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}