import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final controller = scope.wellnessController;
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('sleep_lab')),
        actions: const [AiInfoButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(.15),
                  theme.colorScheme.primary.withOpacity(.05),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loc.translate('sleep_quality'),
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('7h 40m',
                              style: theme.textTheme.displaySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              )),
                          Text(loc.translate('sleep_duration_hint')),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(loc.translate('sleep_efficiency')),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: theme.colorScheme.primary.withOpacity(.2),
                          ),
                          child: const Text('92%'),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _pill(theme, loc.translate('deep_sleep'), '84m'),
                    _pill(theme, loc.translate('rem_sleep'), '60m'),
                    _pill(theme, loc.translate('mindfulness_focus'), 'low stress'),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: .08),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(loc.translate('sleep_timeline'),
                  style: theme.textTheme.titleMedium),
              const Spacer(),
              IconButton(
                icon: const Icon(IconlyLight.refresh),
                onPressed: controller.refreshAll,
              )
            ],
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: controller.sleepTimeline,
            builder: (_, cycles, __) {
              return Column(
                children: cycles
                    .map(
                      (cycle) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: theme.cardColor,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(cycle['stage'] as String? ?? '',
                                      style: theme.textTheme.titleMedium),
                                  const SizedBox(height: 4),
                                  Text('${cycle['duration']} ${loc.translate('minutes')}'),
                                  Text(cycle['highlight'] as String? ?? '',
                                      style: theme.textTheme.bodySmall),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text('${cycle['score']}',
                                    style: theme.textTheme.headlineSmall),
                                Text(loc.translate('impact'),
                                    style: theme.textTheme.bodySmall),
                              ],
                            )
                          ],
                        ),
                      ).animate().slideX(begin: -.06).fadeIn(),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 32),
          Text(loc.translate('night_notes'), style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: theme.colorScheme.secondaryContainer.withOpacity(.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loc.translate('night_notes_hint')),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed('/journey'),
                  icon: const Icon(IconlyLight.chart),
                  label: Text(loc.translate('open_journey')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(ThemeData theme, String label, String value) {
    return Column(
      children: [
        Text(value, style: theme.textTheme.titleLarge),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
