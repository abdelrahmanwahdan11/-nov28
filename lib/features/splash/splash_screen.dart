import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../controller_scope.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final scope = ControllerScope.of(context);
    await scope.themeController.load();
    await scope.localeController.load();
    await Future.delayed(const Duration(milliseconds: 600));
    final seen = scope.prefs.getBool('has_seen_onboarding', defaultValue: false);
    final guest = scope.prefs.getBool('guest_mode', defaultValue: false);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(
      seen
          ? (guest ? '/home_shell' : '/auth')
          : '/onboarding',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(loc.translate('app_name'), style: theme.textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
