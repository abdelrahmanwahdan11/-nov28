import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';
import '../../widgets/skeletons.dart';

class HydrationScreen extends StatelessWidget {
  const HydrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final controller = scope.hydrationController;
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('hydration_hub')),
        actions: [
          IconButton(
            icon: const Icon(IconlyLight.heart),
            tooltip: loc.translate('nutrition_lab'),
            onPressed: () => Navigator.of(context).pushNamed('/nutrition'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            ValueListenableBuilder<double>(
              valueListenable: controller.intakeLiters,
              builder: (_, intake, __) {
                return ValueListenableBuilder<double>(
                  valueListenable: controller.goalLiters,
                  builder: (_, goal, __) {
                    final progress = (intake / goal).clamp(0.0, 1.2);
                    return _HydrationHero(
                      goal: goal,
                      intake: intake,
                      progress: progress,
                      onLog: (amount) => controller.logIntake(amount),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(loc.translate('hydration_timeline'),
                    style: theme.textTheme.titleMedium),
                const Spacer(),
                const AiInfoButton(),
              ],
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<bool>(
              valueListenable: controller.isLoading,
              builder: (_, loading, __) {
                if (loading) {
                  return Column(
                    children: List.generate(
                      3,
                      (index) => const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: SkeletonCard.list(),
                      ),
                    ),
                  );
                }
                return ValueListenableBuilder<List<Map<String, dynamic>>>(
                  valueListenable: controller.timeline,
                  builder: (_, timeline, __) {
                    return Column(
                      children: timeline
                          .map(
                            (item) {
                              final amountRaw = item['amount'];
                              final amount = amountRaw is String
                                  ? double.tryParse(amountRaw) ?? 0
                                  : (amountRaw as num?)?.toDouble() ?? 0;
                              return ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      theme.colorScheme.primary.withOpacity(.2),
                                child: Text('${amount.toStringAsFixed(2)}L'),
                                ),
                                title: Text(item['time'] as String? ?? ''),
                                subtitle: Text(item['mood'] as String? ?? ''),
                                trailing: Icon(
                                  item['mood'] == 'focus'
                                      ? IconlyBold.show
                                      : IconlyLight.more_circle,
                                ),
                              ).animate().fadeIn().slideX(begin: .1);
                            }
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
                Text(loc.translate('hydration_goal'),
                    style: theme.textTheme.titleMedium),
                const Spacer(),
                TextButton(
                  onPressed: () => controller.logIntake(.25),
                  child: Text(loc.translate('log_glass')),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.reminders,
              builder: (_, reminders, __) {
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: reminders
                      .map(
                        (reminder) => FilterChip(
                          label: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(reminder['title'] as String? ?? ''),
                              Text(reminder['time'] as String? ?? '',
                                  style: theme.textTheme.labelSmall),
                            ],
                          ),
                          avatar: Icon(
                            reminder['active'] == true
                                ? IconlyBold.tick_square
                                : IconlyLight.notification,
                          ),
                          selected: reminder['active'] == true,
                          onSelected: (_) =>
                              controller.toggleReminder(reminder['id'] as String),
                        ).animate().scale().fadeIn(),
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

class _HydrationHero extends StatelessWidget {
  const _HydrationHero({
    required this.goal,
    required this.intake,
    required this.progress,
    required this.onLog,
  });

  final double goal;
  final double intake;
  final double progress;
  final ValueChanged<double> onLog;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.secondary.withOpacity(.25),
            theme.colorScheme.primary.withOpacity(.25),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loc.translate('hydration_goal'),
                        style: theme.textTheme.titleMedium),
                    Text('${intake.toStringAsFixed(1)} / ${goal.toStringAsFixed(1)} L'),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(IconlyLight.info_square),
                onPressed: () => showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  builder: (_) => Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(loc.translate('ai_info_placeholder')),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            width: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 180,
                  width: 180,
                  child: CircularProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    strokeWidth: 18,
                  ),
                ).animate().scale(duration: 500.ms),
                Text('${(progress * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.displaySmall),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: () => onLog(.25),
                icon: const Icon(IconlyLight.time_square),
                label: Text(loc.translate('log_glass')),
              ),
              OutlinedButton(
                onPressed: () => onLog(.5),
                child: Text(loc.translate('hydration_refill')),
              ),
            ],
          )
              .animate()
              .fadeIn()
              .slideY(begin: .12, duration: 400.ms, curve: Curves.easeOutCubic),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: .1);
  }
}
