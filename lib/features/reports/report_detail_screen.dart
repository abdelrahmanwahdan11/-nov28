import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/localization/app_localizations.dart';

class ReportDetailScreen extends StatelessWidget {
  const ReportDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final report = (ModalRoute.of(context)?.settings.arguments ??
        {'score': 6.4, 'status': 'Mild concern', 'summary': 'Weekly summary'})
        as Map<String, dynamic>;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('reports'))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                theme.colorScheme.primary.withOpacity(.2),
                theme.colorScheme.primary,
              ]),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              children: [
                Text(report['score'].toStringAsFixed(1),
                    style: theme.textTheme.displayMedium),
                Text(report['status'], style: theme.textTheme.titleMedium),
              ],
            ),
          ).animate().scale(),
          const SizedBox(height: 24),
          Text(report['summary']),
          const SizedBox(height: 24),
          Text('AI Tips', style: theme.textTheme.titleMedium),
          ...List.generate(3, (index) => CheckboxListTile(
                value: false,
                onChanged: (_) {},
                title: Text('Recommendation #${index + 1}'),
              )),
          const SizedBox(height: 24),
          Text('Doctors', style: theme.textTheme.titleMedium),
          ...['Dr. Saeed · Cardio', 'Dr. Laila · Telehealth', 'Dr. Omar · Respiratory']
              .map(
                (doctor) => ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1537368910025-700350fe46c7?auto=format&fit=crop&w=200&q=60'),
                  ),
                  title: Text(doctor),
                  subtitle: const Text('Rating 4.8 · 10 yrs'),
                ),
              ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed('/compare'),
            child: Text(loc.translate('compare')),
          ),
        ],
      ),
    );
  }
}
