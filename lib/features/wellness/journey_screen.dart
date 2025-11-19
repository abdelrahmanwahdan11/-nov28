import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';
import '../../widgets/skeletons.dart';

class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final controller = scope.wellnessController;
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('journey_lab')),
        actions: const [AiInfoButton()],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshAll,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(loc.translate('journey_milestones'),
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ValueListenableBuilder<bool>(
              valueListenable: controller.isLoading,
              builder: (_, loading, __) {
                if (loading) {
                  return Column(
                    children: const [
                      SkeletonCard.list(),
                      SizedBox(height: 12),
                      SkeletonCard.list(),
                    ],
                  );
                }
                return ValueListenableBuilder<List<Map<String, dynamic>>>(
                  valueListenable: controller.journeyMoments,
                  builder: (_, moments, __) {
                    return Column(
                      children: [
                        for (final moment in moments)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary.withOpacity(.18),
                                  theme.colorScheme.primary.withOpacity(.05),
                                ],
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Container(
                                      width: 2,
                                      height: 80,
                                      margin: const EdgeInsets.symmetric(vertical: 4),
                                      color: theme.colorScheme.primary.withOpacity(.2),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              moment['title'] as String? ?? '',
                                              style: theme.textTheme.titleMedium,
                                            ),
                                          ),
                                          Text(moment['time'] as String? ?? '',
                                              style: theme.textTheme.bodySmall),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(moment['description'] as String? ?? '',
                                          style: theme.textTheme.bodySmall),
                                      const SizedBox(height: 10),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: LinearProgressIndicator(
                                          value: (moment['progress'] as num?)?.toDouble() ?? 0,
                                          minHeight: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn().slideY(begin: .1),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 32),
            Text(loc.translate('boosters'), style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.boosters,
              builder: (_, boosters, __) {
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: boosters
                      .map(
                        (item) => FilterChip(
                          label: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(item['title'] as String? ?? ''),
                              Text(item['subtitle'] as String? ?? '',
                                  style: theme.textTheme.bodySmall),
                            ],
                          ),
                          selected: item['completed'] as bool? ?? false,
                          onSelected: (_) => controller.toggleBooster(item['id'] as String),
                        ).animate().scale(),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 32),
            Text(loc.translate('next_steps'), style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.journeyMoments,
              builder: (_, moments, __) {
                final suggestions = moments.take(3).toList();
                return Column(
                  children: suggestions
                      .map(
                        (moment) => ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.primary.withOpacity(.18),
                            child: const Icon(IconlyLight.activity),
                          ),
                          title: Text(moment['title'] as String? ?? ''),
                          subtitle: Text(moment['status'] as String? ?? ''),
                          trailing: IconButton(
                            icon: const Icon(IconlyLight.arrow_right_circle),
                            onPressed: () => Navigator.of(context).pushNamed('/mindfulness'),
                          ),
                        ).animate().slideX(begin: .1).fadeIn(),
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
