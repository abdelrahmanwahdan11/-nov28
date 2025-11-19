import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'controller_scope.dart';
import 'controllers/analysis_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/catalog_controller.dart';
import 'controllers/care_controller.dart';
import 'controllers/checkup_controller.dart';
import 'controllers/compare_controller.dart';
import 'controllers/companion_controller.dart';
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
import 'controllers/insights_controller.dart';
import 'controllers/mission_controller.dart';
import 'controllers/performance_controller.dart';
import 'controllers/wellness_controller.dart';
import 'core/localization/app_localizations.dart';
import 'core/routes/app_router.dart';
import 'core/services/shared_prefs_service.dart';
import 'core/services/sound_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPrefsService.init();
  final themeController = ThemeController(prefs);
  final localeController = LocaleController(prefs);
  final onboardingController = OnboardingController(prefs);
  final authController = AuthController(prefs);
  final homeController = HomeController();
  final dashboardController = DashboardController();
  final analysisController = AnalysisController();
  final checkupController = CheckupController();
  final reportsController = ReportsController();
  final catalogController = CatalogController();
  final compareController = CompareController();
  final profileController = ProfileController();
  final insightsController = InsightsController();
  final wellnessController = WellnessController();
  final nutritionController = NutritionController();
  final hydrationController = HydrationController();
  final communityController = CommunityController();
  final labsController = LabsController();
  final careController = CareController();
  final performanceController = PerformanceController();
  final recoveryController = RecoveryController();
  final missionController = MissionController();
  final companionController = CompanionController();
  final soundService = DebugSoundService();

  runApp(HealthAiApp(
    prefs: prefs,
    themeController: themeController,
    localeController: localeController,
    onboardingController: onboardingController,
    authController: authController,
    homeController: homeController,
    dashboardController: dashboardController,
    analysisController: analysisController,
    checkupController: checkupController,
    reportsController: reportsController,
    catalogController: catalogController,
    compareController: compareController,
    profileController: profileController,
    insightsController: insightsController,
    wellnessController: wellnessController,
    nutritionController: nutritionController,
    hydrationController: hydrationController,
    communityController: communityController,
    labsController: labsController,
    careController: careController,
    performanceController: performanceController,
    recoveryController: recoveryController,
    missionController: missionController,
    companionController: companionController,
    soundService: soundService,
  ));
}

class HealthAiApp extends StatefulWidget {
  const HealthAiApp({
    super.key,
    required this.prefs,
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
    required this.soundService,
  });

  final SharedPrefsService prefs;
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
  final SoundService soundService;

  @override
  State<HealthAiApp> createState() => _HealthAiAppState();
}

class _HealthAiAppState extends State<HealthAiApp> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.themeController,
        widget.localeController,
      ]),
      builder: (context, _) {
        final theme = widget.themeController;
        final locale = widget.localeController;
        return ControllerScope(
          themeController: theme,
          localeController: locale,
          onboardingController: widget.onboardingController,
          authController: widget.authController,
          homeController: widget.homeController,
          dashboardController: widget.dashboardController,
          analysisController: widget.analysisController,
          checkupController: widget.checkupController,
          reportsController: widget.reportsController,
          catalogController: widget.catalogController,
          compareController: widget.compareController,
          profileController: widget.profileController,
          insightsController: widget.insightsController,
          wellnessController: widget.wellnessController,
          nutritionController: widget.nutritionController,
          hydrationController: widget.hydrationController,
          communityController: widget.communityController,
          labsController: widget.labsController,
          careController: widget.careController,
          performanceController: widget.performanceController,
          recoveryController: widget.recoveryController,
          missionController: widget.missionController,
          companionController: widget.companionController,
          prefs: widget.prefs,
          soundService: widget.soundService,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Health AI Checkup',
            theme: AppTheme.buildLight(theme.primaryColor),
            darkTheme: AppTheme.buildDark(theme.primaryColor),
            themeMode: theme.isDark ? ThemeMode.dark : ThemeMode.light,
            locale: locale.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            initialRoute: '/splash',
            onGenerateRoute: AppRouter.generate,
          ),
        );
      },
    );
  }
}
