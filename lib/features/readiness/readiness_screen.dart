import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';
import '../../widgets/skeletons.dart';

class ReadinessScreen extends StatelessWidget {
  const ReadinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final controller = scope.readinessController;
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('readiness_hq')),
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
                return ValueListenableBuilder<Map<String, dynamic>>(
                  valueListenable: controller.orbit,
                  builder: (_, orbit, __) {
                    if (orbit.isEmpty) {
                      return const SkeletonCard.large();
                    }
                    final score = (orbit['score'] as double? ?? .72) * 100;
                    final label = orbit['label'] as String? ?? '';
                    final delta = orbit['delta'] as String? ?? '';
                    final segments = List<Map<String, dynamic>>.from(
                        orbit['segments'] as List? ?? const []);
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(.15),
                            theme.colorScheme.primary.withOpacity(.35),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(loc.translate('home_readiness_title'),
                                        style: theme.textTheme.titleMedium),
                                    Text(label, style: theme.textTheme.bodyMedium),
                                  ],
                                ),
                              ),
                              const AiInfoButton(),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 140,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 140,
                                  height: 140,
                                  child: CircularProgressIndicator(
                                    value: score / 100,
                                    strokeWidth: 12,
                                    backgroundColor:
                                        theme.colorScheme.onPrimary.withOpacity(.1),
                                  ),
                                ),
                                AnimatedSwitcher(
                                  duration: 300.ms,
                                  child: Text(
                                    '${score.toStringAsFixed(0)}%',
                                    key: ValueKey(score.toStringAsFixed(0)),
                                    style: theme.textTheme.displaySmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            children: segments
                                .map(
                                  (segment) => Chip(
                                    label: Text(
                                      '${segment['title']} · '
                                      '${(segment['value'] as num?)?.toStringAsFixed(1)}',
                                    ),
                                  ).animate().fadeIn(),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 12),
                          Text(delta, style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ).animate().fadeIn().slideY(begin: .08);
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            _SectionHeader(
              title: loc.translate('readiness_alerts'),
              action: TextButton(
                onPressed: controller.rotateGuardians,
                child: Text(loc.translate('view_all')),
              ),
            ),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.alerts,
              builder: (_, alerts, __) {
                if (alerts.isEmpty) {
                  return const SkeletonCard.list();
                }
                return Column(
                  children: alerts.map((alert) {
                    final acknowledged = alert['acknowledged'] == true;
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: acknowledged
                              ? theme.colorScheme.primary.withOpacity(.2)
                              : theme.colorScheme.error.withOpacity(.12),
                          child: Icon(
                            acknowledged
                                ? IconlyBold.shield_done
                                : IconlyBold.danger,
                            color: acknowledged
                                ? theme.colorScheme.primary
                                : theme.colorScheme.error,
                          ),
                        ),
                        title: Text(alert['title'] as String? ?? ''),
                        subtitle: Text(alert['message'] as String? ?? ''),
                        trailing: IconButton(
                          icon: Icon(
                            acknowledged
                                ? IconlyBold.tick_square
                                : IconlyLight.time_circle,
                          ),
                          onPressed: () =>
                              controller.acknowledgeAlert(alert['id'] as String),
                        ),
                      ),
                    ).animate().fadeIn().slideX(begin: .05);
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            _SectionHeader(
              title: loc.translate('readiness_protocols'),
              action: IconButton(
                icon: const Icon(IconlyLight.refresh),
                onPressed: controller.refresh,
              ),
            ),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.drills,
              builder: (_, drills, __) {
                if (drills.isEmpty) {
                  return const SkeletonCard.list();
                }
                return Column(
                  children: drills.map((drill) {
                    final completed = drill['completed'] == true;
                    return AnimatedContainer(
                      duration: 300.ms,
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        color: completed
                            ? theme.colorScheme.primary.withOpacity(.12)
                            : theme.cardColor,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(drill['title'] as String? ?? '',
                                    style: theme.textTheme.titleMedium),
                                const SizedBox(height: 4),
                                Text(drill['description'] as String? ?? '',
                                    style: theme.textTheme.bodySmall),
                              ],
                            ),
                          ),
                          Switch(
                            value: completed,
                            onChanged: (_) =>
                                controller.toggleDrill(drill['id'] as String),
                          ),
                        ],
                      ),
                    ).animate().fadeIn().slideY(begin: .05);
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            _SectionHeader(
              title: loc.translate('readiness_guardians'),
              action: IconButton(
                icon: const Icon(Icons.swap_horiz_rounded),
                onPressed: controller.rotateGuardians,
              ),
            ),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.guardians,
              builder: (_, guardians, __) {
                if (guardians.isEmpty) {
                  return const SkeletonCard.list();
                }
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: guardians.map((guardian) {
                    return Chip(
                      avatar: CircleAvatar(
                        backgroundImage: NetworkImage(
                          guardian['avatar'] as String? ??
                              'https://images.unsplash.com/photo-1544723795-3fb6469f5b39',
                        ),
                      ),
                      label: Text('${guardian['name']} · ${guardian['role']}'),
                    ).animate().fadeIn();
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(title, style: theme.textTheme.titleMedium),
        ),
        if (action != null) action!,
      ],
    );
  }
}
