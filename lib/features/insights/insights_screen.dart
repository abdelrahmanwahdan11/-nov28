import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';
import '../../widgets/skeletons.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final controller = scope.insightsController;
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('insights_lab')),
        actions: [
          IconButton(
            icon: const Icon(IconlyLight.voice),
            tooltip: loc.translate('coach_room'),
            onPressed: () => Navigator.of(context).pushNamed('/coach'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
          children: [
            StreamBuilder<double>(
              stream: controller.progressStream.stream,
              builder: (context, snapshot) {
                final progress = snapshot.data ?? .65;
                return AnimatedContainer(
                  duration: 400.ms,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(.25),
                        theme.colorScheme.secondaryContainer
                            .withOpacity(theme.brightness == Brightness.dark ? .4 : .15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(loc.translate('journey_title'),
                          style: theme.textTheme.titleMedium),
                      const SizedBox(height: 12),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
                        duration: 600.ms,
                        curve: Curves.easeOutCubic,
                        builder: (_, value, __) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LinearProgressIndicator(
                              value: value,
                              minHeight: 10,
                              borderRadius: BorderRadius.circular(100),
                              backgroundColor:
                                  theme.colorScheme.onPrimary.withOpacity(.1),
                            ).animate().scaleX(begin: .6, alignment: Alignment.centerLeft),
                            const SizedBox(height: 8),
                            Text('${(value * 100).toStringAsFixed(0)}% ${loc.translate('journey_completed')}',
                                style: theme.textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        children: const [
                          Chip(label: Text('Mindful AM')),
                          Chip(label: Text('Steps+Breath')),
                        ],
                      ).animate().fadeIn(),
                    ],
                  ),
                ).animate().fadeIn(duration: 450.ms).slideY(begin: .1);
              },
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder<int>(
              valueListenable: controller.selectedMood,
              builder: (_, moodIndex, __) {
                final moods = [
                  loc.translate('mood_calm'),
                  loc.translate('mood_focused'),
                  loc.translate('mood_energized'),
                ];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loc.translate('mood_prompt'),
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children: [
                        for (int i = 0; i < moods.length; i++)
                          ChoiceChip(
                            label: Text(moods[i]),
                            selected: moodIndex == i,
                            onSelected: (_) => controller.setMood(i),
                          ).animate().fadeIn(delay: (i * 80).ms),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder<bool>(
              valueListenable: controller.isLoading,
              builder: (_, loading, __) {
                if (loading) {
                  return Column(
                    children: List.generate(
                      3,
                      (index) => const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: SkeletonCard.list(),
                      ),
                    ),
                  );
                }
                return ValueListenableBuilder<List<Map<String, dynamic>>>(
                  valueListenable: controller.insights,
                  builder: (_, insights, __) {
                    if (insights.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(loc.translate('insights_empty')),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        for (int i = 0; i < insights.length; i++)
                          Hero(
                            tag: 'insight-${insights[i]['id']}',
                            child: _InsightCard(
                              data: insights[i],
                              controller: controller,
                              delay: (i * 80).ms,
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            Text(loc.translate('journey_timeline'),
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.journey,
              builder: (_, items, __) {
                if (items.isEmpty) {
                  return const SkeletonCard.list();
                }
                return Column(
                  children: items
                      .map(
                        (item) => ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor:
                                theme.colorScheme.primary.withOpacity(.2),
                            child: Icon(
                              IconlyBold.activity,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          title: Text(item['title'] as String),
                          subtitle: Text(item['description'] as String),
                          trailing: SizedBox(
                            width: 64,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${((item['progress'] as double) * 100).round()}%'),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: (item['progress'] as double).clamp(0.0, 1.0),
                                  minHeight: 6,
                                ),
                              ],
                            ),
                          ),
                        ).animate().slideX(begin: .2).fadeIn(),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed('/coach'),
        icon: const Icon(IconlyLight.chat),
        label: Text(loc.translate('open_coach')),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.data,
    required this.controller,
    required this.delay,
  });

  final Map<String, dynamic> data;
  final dynamic controller;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);
    final Color baseColor = data['color'] as Color? ?? theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            baseColor.withOpacity(.25),
            baseColor.withOpacity(.08),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: baseColor.withOpacity(.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data['title'] as String? ?? '',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              IconButton(
                icon: Icon(
                  (data['favorite'] as bool? ?? false)
                      ? IconlyBold.heart
                      : IconlyLight.heart,
                  color: baseColor,
                ),
                onPressed: () => controller.toggleFavorite(data['id'] as String),
              ),
            ],
          ),
          Text(
            data['summary'] as String? ?? '',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Chip(
                avatar: const Icon(IconlyLight.arrow_up_square, size: 16),
                label: Text('${loc.translate('impact')} ${data['impact']}'),
              ),
              const SizedBox(width: 12),
              Chip(label: Text(data['timeframe'] as String? ?? '')),
              const Spacer(),
              const AiInfoButton(),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final tag in (data['tags'] as List? ?? const []))
                Chip(label: Text('#$tag')),
            ],
          ),
        ],
      ),
    )
        .animate(delay: delay)
        .fadeIn(duration: 350.ms)
        .slideY(begin: .12, curve: Curves.easeOutCubic);
  }
}
