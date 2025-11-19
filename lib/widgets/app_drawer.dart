import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../controller_scope.dart';
import '../core/localization/app_localizations.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final loc = AppLocalizations.of(context);
    final colors = [
      const Color(0xFF71E5A1),
      const Color(0xFF7AD7F0),
      const Color(0xFFFFD65A),
      const Color(0xFFFF6B6B),
    ];
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(loc.translate('app_name'),
                style: Theme.of(context).textTheme.titleLarge),
            SwitchListTile(
              title: Text(loc.translate('dark_mode')),
              value: scope.themeController.isDark,
              onChanged: scope.themeController.toggleDarkMode,
            ),
            ListTile(
              title: Text(loc.translate('primary_color')),
              subtitle: Wrap(
                children: [
                  for (final color in colors)
                    GestureDetector(
                      onTap: () => scope.themeController.updatePrimary(color),
                      child: Container(
                        width: 36,
                        height: 36,
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            ListTile(
              title: Text(loc.translate('language')),
              trailing: DropdownButton<Locale>(
                value: scope.localeController.locale,
                items: const [
                  DropdownMenuItem(value: Locale('en'), child: Text('EN')),
                  DropdownMenuItem(value: Locale('ar'), child: Text('AR')),
                ],
                onChanged: (locale) {
                  if (locale != null) scope.localeController.setLocale(locale);
                },
              ),
            ),
            ListTile(
              title: Text(loc.translate('drawer_about')),
              onTap: () {},
            ),
            ListTile(
              title: Text(loc.translate('drawer_privacy')),
              onTap: () {},
            ),
            ListTile(
              title: Text(loc.translate('insights_lab')),
              trailing: const Icon(IconlyLight.arrow_right_circle),
              onTap: () => Navigator.of(context).pushNamed('/insights'),
            ),
            ListTile(
              title: Text(loc.translate('coach_room')),
              trailing: const Icon(IconlyLight.chat),
              onTap: () => Navigator.of(context).pushNamed('/coach'),
            ),
            ListTile(
              title: Text(loc.translate('settings')),
              onTap: () => Navigator.of(context).pushNamed('/settings'),
            ),
          ],
        ).animate().fadeIn(duration: 350.ms),
      ),
    );
  }
}
