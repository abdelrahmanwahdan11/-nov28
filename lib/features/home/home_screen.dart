import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';
import '../../widgets/skeletons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final controller = scope.homeController;
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    final body = RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${loc.translate('profile_greeting')} ${scope.profileController.profile.value['name']}',
                        style: theme.textTheme.titleLarge),
                    Text(loc.translate('greeting_ready'),
                        style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(IconlyLight.search),
                onPressed: () => Navigator.of(context).pushNamed('/catalog'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ValueListenableBuilder<bool>(
            valueListenable: controller.isLoading,
            builder: (_, loading, __) {
              if (loading) {
                return const SkeletonCard.large();
              }
              return ValueListenableBuilder<double>(
                valueListenable: controller.healthScore,
                builder: (_, score, __) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(.15),
                          theme.colorScheme.primary.withOpacity(.35),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(loc.translate('health_score'),
                            style: theme.textTheme.titleMedium),
                        const SizedBox(height: 12),
                        AnimatedSwitcher(
                          duration: 300.ms,
                          child: Text(
                            score.toStringAsFixed(1),
                            key: ValueKey(score),
                            style: theme.textTheme.displayMedium,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => _showEmergencyModal(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFFFFD65A),
                                foregroundColor: Colors.black,
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                              ),
                              child: Text(loc.translate('emergency')),
                            ),
                            const Spacer(),
                            const AiInfoButton(),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn().scale();
                },
              );
            },
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text('Vitals', style: theme.textTheme.titleMedium),
              const Spacer(),
              IconButton(
                icon: const Icon(IconlyLight.search),
                onPressed: () => Navigator.of(context).pushNamed('/analysis_detail'),
              ),
            ],
          ),
          SizedBox(
            height: 160,
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.vitals,
              builder: (_, vitals, __) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: vitals.length,
                  itemBuilder: (_, index) {
                    final vital = vitals[index];
                    return GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed('/analysis_detail'),
                      child: Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(vital['type'],
                                style: theme.textTheme.titleSmall),
                            const Spacer(),
                            Text('${vital['value']} ${vital['unit']}',
                                style: theme.textTheme.titleLarge),
                            Text('${vital['score']} / 10'),
                          ],
                        ),
                      ).animate().slideX(begin: .1).fadeIn(),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Text(loc.translate('daily_highlights'),
              style: theme.textTheme.titleMedium),
          ValueListenableBuilder<List<Map<String, String>>>(
            valueListenable: controller.reminders,
            builder: (_, reminders, __) {
              return Column(
                children: reminders
                    .map(
                      (reminder) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              theme.colorScheme.primary.withOpacity(.2),
                          child: const Icon(IconlyLight.calendar),
                        ),
                        title: Text(reminder['title'] ?? ''),
                        subtitle: Text(reminder['time'] ?? ''),
                        trailing: IconButton(
                          icon: const Icon(IconlyLight.info_square),
                          onPressed: () => _showEmergencyModal(context),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );

    return Directionality(
      textDirection: Directionality.of(context),
      child: body,
    );
  }

  void _showEmergencyModal(BuildContext context) {
    final loc = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(loc.translate('emergency'),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text('Call 911 or share live vitals with your guardian.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(loc.translate('call_emergency')),
            ),
          ],
        ),
      ),
    );
  }
}
