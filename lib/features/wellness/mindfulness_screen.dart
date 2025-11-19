import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';

class MindfulnessScreen extends StatelessWidget {
  const MindfulnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final controller = scope.wellnessController;
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final moods = [
      ('calm', loc.translate('mood_calm')),
      ('focused', loc.translate('mood_focused')),
      ('energized', loc.translate('mood_energized')),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('mindfulness_room')),
        actions: const [AiInfoButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(loc.translate('mood_prompt'), style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          ValueListenableBuilder<String>(
            valueListenable: controller.selectedMood,
            builder: (_, mood, __) {
              return Wrap(
                spacing: 12,
                children: moods
                    .map(
                      (item) => ChoiceChip(
                        label: Text(item.$2),
                        selected: mood == item.$1,
                        onSelected: (_) => controller.setMood(item.$1),
                      ).animate().scale(),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withOpacity(.2),
                  theme.colorScheme.primary.withOpacity(.05),
                ],
              ),
            ),
            child: Column(
              children: [
                Text(loc.translate('breath_prompt'),
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: StreamBuilder<double>(
                    stream: controller.breathingProgressController.stream,
                    builder: (_, snapshot) {
                      final progress = snapshot.data ?? 0;
                      return AnimatedContainer(
                        duration: 400.ms,
                        curve: Curves.easeOutCubic,
                        width: 120 + (progress * 80),
                        height: 120 + (progress * 80),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withOpacity(.4),
                              blurRadius: 60 * progress,
                              spreadRadius: 20 * progress,
                            ),
                          ],
                          gradient: RadialGradient(
                            colors: [
                              theme.colorScheme.primary.withOpacity(.7),
                              theme.colorScheme.primary.withOpacity(.2),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            progress < .5
                                ? loc.translate('inhale_label')
                                : loc.translate('exhale_label'),
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ).animate().fadeIn();
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Text(loc.translate('breathing_exercise'),
                    style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Text(loc.translate('guided_sessions'),
                  style: theme.textTheme.titleMedium),
              const Spacer(),
              IconButton(
                icon: const Icon(IconlyLight.play),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: controller.mindfulnessSessions,
            builder: (_, sessions, __) {
              return Column(
                children: sessions
                    .map(
                      (session) => Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color: theme.cardColor,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(session['title'] as String? ?? '',
                                      style: theme.textTheme.titleMedium),
                                  Text(session['duration'] as String? ?? ''),
                                  Text(
                                    session['focus'] as String? ?? '',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    controller.completeSession(session['id'] as String);
                                    // TODO: hook SoundService.playSuccess when audio added
                                  },
                                  child: Text(loc.translate('start_session')),
                                ),
                                const SizedBox(height: 4),
                                Icon(
                                  session['completed'] == true
                                      ? IconlyBold.tick_square
                                      : IconlyLight.paper,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ).animate().slideX(begin: .08).fadeIn(),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
