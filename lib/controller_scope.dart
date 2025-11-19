import 'package:flutter/widgets.dart';

import 'controllers/analysis_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/catalog_controller.dart';
import 'controllers/care_controller.dart';
import 'controllers/checkup_controller.dart';
import 'controllers/community_controller.dart';
import 'controllers/dashboard_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/hydration_controller.dart';
import 'controllers/labs_controller.dart';
import 'controllers/locale_controller.dart';
import 'controllers/nutrition_controller.dart';
import 'controllers/onboarding_controller.dart';
import 'controllers/profile_controller.dart';
import 'controllers/recovery_controller.dart';
import 'controllers/reports_controller.dart';
import 'controllers/theme_controller.dart';
import 'controllers/compare_controller.dart';
import 'controllers/companion_controller.dart';
import 'controllers/insights_controller.dart';
import 'controllers/mission_controller.dart';
import 'controllers/moments_controller.dart';
import 'controllers/performance_controller.dart';
import 'controllers/readiness_controller.dart';
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
    required this.nutritionController,
    required this.hydrationController,
    required this.communityController,
    required this.labsController,
    required this.careController,
    required this.performanceController,
    required this.recoveryController,
    required this.missionController,
    required this.companionController,
    required this.readinessController,
    required this.momentsController,
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
  final NutritionController nutritionController;
  final HydrationController hydrationController;
  final CommunityController communityController;
  final LabsController labsController;
  final CareController careController;
  final PerformanceController performanceController;
  final RecoveryController recoveryController;
  final MissionController missionController;
  final CompanionController companionController;
  final ReadinessController readinessController;
  final MomentsController momentsController;
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
