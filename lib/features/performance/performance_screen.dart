import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';
import '../../widgets/skeletons.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final controller = scope.performanceController;
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('performance_lab')),
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
            ValueListenableBuilder<bool>(
              valueListenable: controller.isLoading,
              builder: (_, loading, __) {
                if (loading) {
                  return const SkeletonCard.large();
                }
                return ValueListenableBuilder<double>(
                  valueListenable: controller.readinessScore,
                  builder: (_, score, __) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(.15),
                            theme.colorScheme.primary.withOpacity(.4),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(36),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(loc.translate('readiness_score'),
                              style: theme.textTheme.titleMedium),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: AnimatedSwitcher(
                                  duration: 400.ms,
                                  transitionBuilder: (child, anim) =>
                                      ScaleTransition(scale: anim, child: child),
                                  child: Text(
                                    score.toStringAsFixed(1),
                                    key: ValueKey(score.toStringAsFixed(1)),
                                    style: theme.textTheme.displayMedium,
                                  ),
                                ),
                              ),
                              const AiInfoButton(),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(loc.translate('home_performance_subtitle'),
                              style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    ).animate().fadeIn().slideY(begin: .1);
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            Text(loc.translate('movement_sessions'),
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.sessions,
              builder: (_, sessions, __) {
                if (sessions.isEmpty) {
                  return const SkeletonCard.list();
                }
                return Column(
                  children: sessions.map((session) {
                    final completed = session['completed'] == true;
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(20),
                        leading: CircleAvatar(
                          backgroundColor:
                              theme.colorScheme.primary.withOpacity(.15),
                          child: Icon(
                            completed
                                ? IconlyBold.tick_square
                                : IconlyLight.play,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        title: Text(session['title'] as String? ?? ''),
                        subtitle: Text(
                          '${session['duration']} · ${session['intensity']} bpm',
                        ),
                        trailing: Switch(
                          value: completed,
                          onChanged: (_) => controller
                              .toggleSession(session['id'] as String),
                        ),
                        onTap: () => controller
                            .toggleSession(session['id'] as String),
                      ),
                    ).animate().fadeIn().slideX(begin: .08);
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(loc.translate('mobility_heat'),
                      style: theme.textTheme.titleMedium),
                ),
                IconButton(
                  icon: const Icon(Icons.fullscreen),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.mobilityHeat,
              builder: (_, zones, __) {
                if (zones.isEmpty) {
                  return const SkeletonCard.list();
                }
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: zones.map((zone) {
                    final percent = ((zone['score'] as double?) ?? 0) / 100;
                    return AnimatedContainer(
                      duration: 350.ms,
                      curve: Curves.easeOutCubic,
                      width: 150,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        color: theme.cardColor,
                        border: Border.all(
                          color:
                              theme.colorScheme.primary.withOpacity(percent),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(zone['zone'] as String? ?? ''),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: percent.clamp(0.0, 1.0),
                            minHeight: 6,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          const SizedBox(height: 4),
                          Text('${(percent * 100).round()}% mobile'),
                        ],
                      ),
                    ).animate().scale().fadeIn();
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(loc.translate('journey_timeline'),
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.timeline,
              builder: (_, timeline, __) {
                if (timeline.isEmpty) {
                  return const SkeletonCard.list();
                }
                return Column(
                  children: timeline.map((entry) {
                    final expanded = entry['expanded'] == true;
                    return AnimatedContainer(
                      duration: 300.ms,
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        color: theme.cardColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(entry['title'] as String? ?? '',
                                    style: theme.textTheme.titleMedium),
                              ),
                              IconButton(
                                icon: Icon(
                                  expanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                ),
                                onPressed: () => controller
                                    .toggleTimeline(entry['id'] as String),
                              ),
                            ],
                          ),
                          AnimatedCrossFade(
                            crossFadeState: expanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            firstChild: const SizedBox.shrink(),
                            secondChild: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(entry['detail'] as String? ?? ''),
                            ),
                            duration: 250.ms,
                          ),
                        ],
                      ),
                    ).animate().fadeIn().slideY(begin: .08);
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
