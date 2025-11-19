import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';
import '../../widgets/skeletons.dart';

class MissionScreen extends StatelessWidget {
  const MissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ControllerScope.of(context).missionController;
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('mission_control')),
        actions: const [AiInfoButton()],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: controller.isLoading,
              builder: (_, loading, __) {
                return AnimatedOpacity(
                  duration: 250.ms,
                  opacity: loading ? 1 : 0,
                  child: loading ? const LinearProgressIndicator() : null,
                );
              },
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<double>(
              valueListenable: controller.readiness,
              builder: (_, readiness, __) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    gradient: LinearGradient(colors: [
                      theme.colorScheme.primary.withOpacity(.15),
                      theme.colorScheme.primary.withOpacity(.35),
                    ]),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(loc.translate('mission_readiness'),
                                style: theme.textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text(
                              loc.translate('home_companion_subtitle'),
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () =>
                                  Navigator.of(context).pushNamed('/companion'),
                              child: Text(loc.translate('open_mission')),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: readiness),
                          duration: 400.ms,
                          builder: (_, value, __) {
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                CircularProgressIndicator(
                                  value: value,
                                  strokeWidth: 10,
                                  backgroundColor: theme
                                      .colorScheme.onPrimary
                                      .withOpacity(.1),
                                ),
                                Center(
                                  child: Text(
                                    '${(value * 100).round()}%',
                                    style: theme.textTheme.headlineSmall,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: .1);
              },
            ),
            const SizedBox(height: 24),
            _SectionTitle(text: loc.translate('mission_pillars')),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.pillars,
              builder: (_, pillars, __) {
                if (pillars.isEmpty) {
                  return Wrap(
                    spacing: 12,
                    children: const [SkeletonChip(), SkeletonChip(), SkeletonChip()],
                  );
                }
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: pillars.map((pillar) {
                    final active = pillar['active'] == true;
                    return AnimatedContainer(
                      duration: 250.ms,
                      padding: const EdgeInsets.all(16),
                      width: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        color: active
                            ? theme.colorScheme.primary.withOpacity(.18)
                            : theme.cardColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pillar['title'] as String,
                              style: theme.textTheme.titleSmall),
                          const SizedBox(height: 6),
                          Text(pillar['subtitle'] as String,
                              style: theme.textTheme.bodySmall),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Switch(
                              value: active,
                              onChanged: (_) => controller
                                  .togglePillar(pillar['id'] as String),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn();
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            _SectionTitle(text: loc.translate('mission_rituals')),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.rituals,
              builder: (_, rituals, __) {
                if (rituals.isEmpty) {
                  return const SkeletonCard.list();
                }
                return Column(
                  children: rituals.map((ritual) {
                    final done = ritual['completed'] == true;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      leading: Icon(
                        done ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: done
                            ? theme.colorScheme.primary
                            : theme.disabledColor,
                      ),
                      title: Text(ritual['title'] as String),
                      subtitle: Text(ritual['duration'] as String),
                      trailing: ElevatedButton(
                        onPressed: () => controller
                            .completeRitual(ritual['id'] as String),
                        child: Text(loc.translate('start_micro_goal')),
                      ),
                      onTap: () =>
                          controller.completeRitual(ritual['id'] as String),
                    ).animate().fadeIn();
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            _SectionTitle(text: loc.translate('mission_timeline')),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.missions,
              builder: (_, missions, __) {
                if (missions.isEmpty) {
                  return const SkeletonCard.large();
                }
                return Column(
                  children: missions.map((mission) {
                    final progress = mission['progress'] as double? ?? .5;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: theme.cardColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(mission['title'] as String,
                              style: theme.textTheme.titleMedium),
                          const SizedBox(height: 6),
                          Text(mission['summary'] as String,
                              style: theme.textTheme.bodySmall),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: LinearProgressIndicator(value: progress),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text('${(progress * 100).round()}%'),
                              const Spacer(),
                              Text(mission['eta'] as String),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn().slideY(begin: .1);
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.titleMedium);
  }
}
