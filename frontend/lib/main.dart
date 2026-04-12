import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'features/accident_report/presentation/pages/report_accident_page.dart';
import 'features/fb_feed/presentation/pages/fb_feed_page.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/hotspots/presentation/pages/hotspots_page.dart';
import 'features/about/presentation/pages/about_page.dart';
import 'core/navigation/main_navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MauTrafficApp()));
}

class MauTrafficApp extends StatelessWidget {
  const MauTrafficApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashPage(),
        '/': (_) => const MainNavigation(),
        '/report-accident': (_) => const ReportAccidentPage(),
        '/fb-feed': (_) => const FbFeedPage(),
        '/hotspots': (_) => const HotspotsPage(),
        '/about': (_) => const AboutPage()
      },
    );
  }
}