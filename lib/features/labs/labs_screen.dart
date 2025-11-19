import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';
import '../../widgets/skeletons.dart';

class LabsScreen extends StatelessWidget {
  const LabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final controller = scope.labsController;
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final filters = [
      ('all', loc.translate('labs_filter_all')),
      ('blood', loc.translate('labs_filter_blood')),
      ('genetics', loc.translate('labs_filter_genetics')),
      ('microbiome', loc.translate('labs_filter_microbiome')),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('labs_hub')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.refresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.timeline,
              builder: (_, timeline, __) {
                if (timeline.isEmpty) {
                  return const SkeletonCard.large();
                }
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(.18),
                        theme.colorScheme.primary.withOpacity(.05),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(loc.translate('labs_timeline'),
                                style: theme.textTheme.titleMedium),
                          ),
                          const AiInfoButton(),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...timeline.map(
                        (step) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor:
                                theme.colorScheme.primary.withOpacity(.2),
                            child: Icon(
                              step['completed'] == true
                                  ? IconlyBold.tick_square
                                  : IconlyLight.time_circle,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          title: Text(step['label'] as String? ?? ''),
                          subtitle: Text(step['detail'] as String? ?? ''),
                          trailing: Text(step['eta'] as String? ?? ''),
                        ).animate().fadeIn(duration: 300.ms).slideX(begin: .1),
                      ),
                    ],
                  ),
                ).animate().fadeIn().scale();
              },
            ),
            const SizedBox(height: 24),
            Text(loc.translate('labs_upcoming'),
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ValueListenableBuilder<String>(
              valueListenable: controller.selectedFilter,
              builder: (_, selected, __) {
                return Wrap(
                  spacing: 12,
                  children: filters
                      .map(
                        (filter) => ChoiceChip(
                          label: Text(filter.$2),
                          selected: selected == filter.$1,
                          onSelected: (_) => controller.setFilter(filter.$1),
                        ).animate().scale(),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.upcomingTests,
              builder: (_, tests, __) {
                if (tests.isEmpty) {
                  return const SkeletonCard.list();
                }
                return ValueListenableBuilder<String>(
                  valueListenable: controller.selectedFilter,
                  builder: (_, selected, __) {
                    final filtered = selected == 'all'
                        ? tests
                        : tests
                            .where((test) => test['type'] == selected)
                            .toList();
                    return Column(
                      children: filtered
                          .map(
                            (test) => Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(20),
                                leading: CircleAvatar(
                                  backgroundColor: theme.colorScheme.primary
                                      .withOpacity(.15),
                                  child: Icon(
                                    IconlyBold.activity,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                title: Text(test['title'] as String? ?? ''),
                                subtitle: Text(
                                  '${test['window']} · ${test['location']}',
                                ),
                                trailing: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(test['status'] as String? ?? ''),
                                    Text(test['preparation'] as String? ?? ''),
                                  ],
                                ),
                              ),
                            ).animate().fadeIn().slideX(begin: .1),
                          )
                          .toList(),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(loc.translate('labs_results'),
                      style: theme.textTheme.titleMedium),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(loc.translate('view_all')),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.recentResults,
              builder: (_, results, __) {
                if (results.isEmpty) {
                  return const SkeletonCard.list();
                }
                return Column(
                  children: results
                      .map(
                        (result) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            color: theme.cardColor,
                            border: Border.all(
                              color: (result['status'] == 'high'
                                      ? Colors.orange
                                      : theme.colorScheme.primary)
                                  .withOpacity(.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(result['marker'] as String? ?? '',
                                        style: theme.textTheme.titleMedium),
                                    Text(result['summary'] as String? ?? ''),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('${result['value']} ${result['unit']}'),
                                  const SizedBox(height: 4),
                                  OutlinedButton(
                                    onPressed: () => controller
                                        .acknowledgeResult(result['id'] as String),
                                    child: Text(
                                      (result['acknowledged'] as bool? ?? false)
                                          ? loc.translate('done')
                                          : loc.translate('continue'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).animate().fadeIn().slideY(begin: .1),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(loc.translate('labs_kits'),
                      style: theme.textTheme.titleMedium),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/mission'),
                  child: Text(loc.translate('labs_schedule_cta')),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.sampleKits,
              builder: (_, kits, __) {
                if (kits.isEmpty) {
                  return const SkeletonCard.list();
                }
                return Column(
                  children: kits
                      .map(
                        (kit) => ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          tileColor: theme.cardColor,
                          leading: CircleAvatar(
                            backgroundColor:
                                theme.colorScheme.primary.withOpacity(.15),
                            child: Icon(
                              kit['completed'] == true
                                  ? IconlyBold.tick_square
                                  : IconlyLight.send,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          title: Text(kit['title'] as String? ?? ''),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(kit['status'] as String? ?? ''),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: (kit['progress'] as double?)
                                        ?.clamp(0.0, 1.0) ??
                                    0,
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(IconlyLight.edit),
                            onPressed: () => controller
                                .toggleKitStatus(kit['id'] as String),
                          ),
                        ).animate().fadeIn().slideX(begin: -.08),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
