import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ControllerScope.of(context).profileController;
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final profile = controller.profile.value;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        CircleAvatar(
          radius: 40,
          child: Text(profile['name'][0]),
        ),
        const SizedBox(height: 12),
        Text(profile['name'], style: theme.textTheme.headlineSmall),
        Text('${loc.translate('bmi')}: ${controller.bmi.toStringAsFixed(1)}'),
        const SizedBox(height: 24),
        ListTile(
          leading: const Icon(IconlyLight.setting),
          title: Text(loc.translate('settings')),
          onTap: () => Navigator.of(context).pushNamed('/settings'),
        ),
        ListTile(
          leading: const Icon(IconlyLight.paper),
          title: Text(loc.translate('reports')),
          onTap: () => Navigator.of(context).pushNamed('/reports'),
        ),
      ],
    );
  }
}
