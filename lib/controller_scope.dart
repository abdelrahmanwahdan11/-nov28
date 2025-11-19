import 'package:flutter/widgets.dart';

import 'controllers/analysis_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/catalog_controller.dart';
import 'controllers/checkup_controller.dart';
import 'controllers/dashboard_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/locale_controller.dart';
import 'controllers/onboarding_controller.dart';
import 'controllers/profile_controller.dart';
import 'controllers/reports_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/compare_controller.dart';
import 'controllers/insights_controller.dart';
import 'controllers/wellness_controller.dart';
import 'core/services/shared_prefs_service.dart';
import 'core/services/sound_service.dart';

class ControllerScope extends InheritedWidget {
  const ControllerScope({
    super.key,
    required super.child,
    required this.themeController,
    required this.localeController,
    required this.onboardingController,
    required this.authController,
    required this.homeController,
    required this.dashboardController,
    required this.analysisController,
    required this.checkupController,
    required this.reportsController,
    required this.catalogController,
    required this.compareController,
    required this.profileController,
    required this.insightsController,
    required this.wellnessController,
    required this.prefs,
    required this.soundService,
  });

  final ThemeController themeController;
  final LocaleController localeController;
  final OnboardingController onboardingController;
  final AuthController authController;
  final HomeController homeController;
  final DashboardController dashboardController;
  final AnalysisController analysisController;
  final CheckupController checkupController;
  final ReportsController reportsController;
  final CatalogController catalogController;
  final CompareController compareController;
  final ProfileController profileController;
  final InsightsController insightsController;
  final WellnessController wellnessController;
  final SharedPrefsService prefs;
  final SoundService soundService;

  static ControllerScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ControllerScope>();
    assert(scope != null, 'ControllerScope not found');
    return scope!;
  }

  @override
  bool updateShouldNotify(covariant ControllerScope oldWidget) => false;
}
