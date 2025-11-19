import 'package:flutter/material.dart';

import '../../features/analysis/analysis_screen.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/catalog/catalog_screen.dart';
import '../../features/checkup/checkup_screen.dart';
import '../../features/compare/compare_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/home/home_shell.dart';
import '../../features/insights/coach_screen.dart';
import '../../features/insights/insights_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/reports/report_detail_screen.dart';
import '../../features/reports/reports_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/splash/splash_screen.dart';

class AppRouter {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case '/auth':
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case '/home_shell':
        return MaterialPageRoute(builder: (_) => const HomeShell());
      case '/analysis_detail':
        return MaterialPageRoute(builder: (_) => const AnalysisScreen());
      case '/checkup_device':
        return MaterialPageRoute(
            builder: (_) => const CheckupScreen(initialTabIndex: 0));
      case '/checkup_ai':
        return MaterialPageRoute(
            builder: (_) => const CheckupScreen(initialTabIndex: 1));
      case '/report_detail':
        return MaterialPageRoute(builder: (_) => const ReportDetailScreen());
      case '/reports':
        return MaterialPageRoute(builder: (_) => const ReportsScreen());
      case '/catalog':
        return MaterialPageRoute(builder: (_) => CatalogScreen(standalone: true));
      case '/compare':
        return MaterialPageRoute(builder: (_) => const CompareScreen());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case '/insights':
        return MaterialPageRoute(builder: (_) => const InsightsScreen());
      case '/coach':
        return MaterialPageRoute(builder: (_) => const CoachScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route ${settings.name} not found')),
          ),
        );
    }
  }
}
