import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';

class CoachScreen extends StatelessWidget {
  const CoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final controller = scope.insightsController;
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('coach_room')),
        actions: const [AiInfoButton()],
      ),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: controller.coachPlan,
        builder: (_, plans, __) {
          if (plans.isEmpty) {
            return Center(
              child: Text(loc.translate('coach_empty')),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(loc.translate('coach_intro'),
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 16),
              _coachHero(theme, loc).animate().scale(delay: 120.ms),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                children: [
                  FilterChip(
                    label: Text(loc.translate('coach_focus_body')),
                    selected: true,
                    onSelected: (_) {},
                  ),
                  FilterChip(
                    label: Text(loc.translate('coach_focus_mind')),
                    selected: false,
                    onSelected: (_) {},
                  ),
                ],
              ).animate().fadeIn(),
              const SizedBox(height: 16),
              ...plans.map(
                (plan) => AnimatedContainer(
                  duration: 350.ms,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: plan['completed'] == true
                        ? theme.colorScheme.primary.withOpacity(.15)
                        : theme.cardColor,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor:
                            theme.colorScheme.primary.withOpacity(.2),
                        child: Icon(IconlyBold.activity,
                            color: theme.colorScheme.primary),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(plan['title'] as String,
                                style: theme.textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text(plan['detail'] as String,
                                style: theme.textTheme.bodyMedium),
                            const SizedBox(height: 8),
                            Text(plan['duration'] as String,
                                style: theme.textTheme.labelMedium),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          plan['completed'] == true
                              ? IconlyBold.shield_done
                              : IconlyLight.play,
                          color: theme.colorScheme.primary,
                        ),
                        onPressed: () {
                          controller.completePlanStep(plan['id'] as String);
                          scope.soundService.playSuccess();
                        },
                      ),
                    ],
                  ),
                ).animate().slideY(begin: .1).fadeIn(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _coachHero(ThemeData theme, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(.2),
            theme.colorScheme.secondary.withOpacity(.15),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(loc.translate('coach_card_title'),
                    style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(loc.translate('coach_card_subtitle')),
                const SizedBox(height: 12),
                FilledButton.tonal(
                  onPressed: () {},
                  child: Text(loc.translate('start_micro_goal')),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: AspectRatio(
              aspectRatio: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary.withOpacity(.08),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(IconlyBold.voice, size: 64),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
