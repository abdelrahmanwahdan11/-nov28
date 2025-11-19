import 'package:flutter/material.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;

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
    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('settings'))),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(loc.translate('dark_mode')),
            value: scope.themeController.isDark,
            onChanged: scope.themeController.toggleDarkMode,
          ),
          SwitchListTile(
            title: Text(loc.translate('notifications')),
            value: notifications,
            onChanged: (value) => setState(() => notifications = value),
          ),
          ListTile(
            title: Text(loc.translate('primary_color')),
            subtitle: Wrap(
              spacing: 12,
              children: colors
                  .map(
                    (color) => GestureDetector(
                      onTap: () => scope.themeController.updatePrimary(color),
                      child: CircleAvatar(backgroundColor: color),
                    ),
                  )
                  .toList(),
            ),
          ),
          ListTile(
            title: Text(loc.translate('language')),
            trailing: DropdownButton<Locale>(
              value: scope.localeController.locale,
              items: const [
                DropdownMenuItem(value: Locale('en'), child: Text('English')),
                DropdownMenuItem(value: Locale('ar'), child: Text('العربية')),
              ],
              onChanged: (locale) {
                if (locale != null) scope.localeController.setLocale(locale);
              },
            ),
          ),
        ],
      ),
    );
  }
}
