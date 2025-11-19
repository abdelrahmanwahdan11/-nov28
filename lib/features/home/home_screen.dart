import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../controllers/community_controller.dart';
import '../../controllers/companion_controller.dart';
import '../../controllers/hydration_controller.dart';
import '../../controllers/mission_controller.dart';
import '../../controllers/nutrition_controller.dart';
import '../../controllers/performance_controller.dart';
import '../../controllers/recovery_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';
import '../../widgets/skeletons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final controller = scope.homeController;
    final insightsController = scope.insightsController;
    final wellnessController = scope.wellnessController;
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);
    final nutritionController = scope.nutritionController;
    final hydrationController = scope.hydrationController;
    final communityController = scope.communityController;
    final performanceController = scope.performanceController;
    final recoveryController = scope.recoveryController;
    final missionController = scope.missionController;
    final companionController = scope.companionController;
    final moods = [
      ('calm', loc.translate('mood_calm')),
      ('focused', loc.translate('mood_focused')),
      ('energized', loc.translate('mood_energized')),
    ];

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
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loc.translate('home_insights_title'),
                        style: theme.textTheme.titleMedium),
                    Text(loc.translate('home_insights_subtitle'),
                        style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/insights'),
                child: Text(loc.translate('view_all')),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<bool>(
            valueListenable: insightsController.isLoading,
            builder: (_, loading, __) {
              if (loading) {
                return const SkeletonCard.list();
              }
              return ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable: insightsController.insights,
                builder: (_, insights, __) {
                  if (insights.isEmpty) {
                    return Text(loc.translate('insights_empty'));
                  }
                  return Column(
                    children: insights
                        .take(2)
                        .map(
                          (insight) => GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed('/insights'),
                            child: Hero(
                              tag: 'insight-${insight['id']}',
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary.withOpacity(.18),
                                      theme.colorScheme.primary.withOpacity(.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(insight['title'] as String? ?? '',
                                              style: theme.textTheme.titleMedium),
                                          const SizedBox(height: 4),
                                          Text(insight['summary'] as String? ?? '',
                                              style: theme.textTheme.bodySmall),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('${insight['impact']}',
                                            style: theme.textTheme.headlineSmall),
                                        Text(loc.translate('impact'),
                                            style: theme.textTheme.bodySmall),
                                      ],
                                    ),
                                  ],
                                ),
                              ).animate().fadeIn().slideX(begin: .1),
                            ),
                          ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(loc.translate('home_wellness_title'),
                        style: theme.textTheme.titleMedium),
                    Text(loc.translate('home_wellness_subtitle'),
                        style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed('/mindfulness'),
                child: Text(loc.translate('open_journey')),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<String>(
            valueListenable: wellnessController.selectedMood,
            builder: (_, mood, __) {
              return Wrap(
                spacing: 12,
                children: moods
                    .map(
                      (entry) => ChoiceChip(
                        label: Text(entry.$2),
                        selected: mood == entry.$1,
                        onSelected: (_) => wellnessController.setMood(entry.$1),
                      ).animate().scale(),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: wellnessController.boosters,
              builder: (_, boosters, __) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: boosters.length,
                  itemBuilder: (context, index) {
                    final booster = boosters[index];
                    return Container(
                      width: 200,
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        color: theme.cardColor,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(booster['title'] as String? ?? '',
                              style: theme.textTheme.titleMedium),
                          Text(booster['subtitle'] as String? ?? '',
                              style: theme.textTheme.bodySmall),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: IconButton(
                              icon: Icon(
                                booster['completed'] == true
                                    ? IconlyBold.tick_square
                                    : IconlyLight.play,
                              ),
                              onPressed: () => wellnessController
                                  .toggleBooster(booster['id'] as String),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn().slideX(begin: .08);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _WellnessCard(
                  title: loc.translate('mindfulness_room'),
                  subtitle: loc.translate('breathing_exercise'),
                  imageUrl:
                      'https://images.unsplash.com/photo-1524504388940-b1c1722653e1',
                  onTap: () => Navigator.of(context).pushNamed('/mindfulness'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _WellnessCard(
                  title: loc.translate('sleep_lab'),
                  subtitle: loc.translate('sleep_quality'),
                  imageUrl:
                      'https://images.unsplash.com/photo-1506126613408-eca07ce68773',
                  onTap: () => Navigator.of(context).pushNamed('/sleep'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _NutritionPreview(controller: nutritionController),
          const SizedBox(height: 24),
          _HydrationPreview(controller: hydrationController),
          const SizedBox(height: 24),
          _CommunityPreview(controller: communityController),
          const SizedBox(height: 24),
          _PerformancePreview(controller: performanceController),
          const SizedBox(height: 24),
          _RecoveryPreview(controller: recoveryController),
          const SizedBox(height: 24),
          _MissionPreview(controller: missionController),
          const SizedBox(height: 24),
          _CompanionPreview(controller: companionController),
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

class _WellnessCard extends StatelessWidget {
  const _WellnessCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: theme.cardColor,
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(.35),
              BlendMode.darken,
            ),
          ),
        ),
        padding: const EdgeInsets.all(20),
        alignment: Alignment.bottomLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: theme.textTheme.titleLarge
                    ?.copyWith(color: Colors.white)),
            Text(subtitle,
                style:
                    theme.textTheme.bodySmall?.copyWith(color: Colors.white70)),
          ],
        ),
      ).animate().scale().fadeIn(),
    );
  }
}

class _NutritionPreview extends StatelessWidget {
  const _NutritionPreview({required this.controller});

  final NutritionController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.translate('home_nutrition_title'),
                      style: theme.textTheme.titleMedium),
                  Text(loc.translate('home_nutrition_subtitle'),
                      style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/nutrition'),
              child: Text(loc.translate('view_all')),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: controller.mealPlans,
          builder: (_, meals, __) {
            if (meals.isEmpty) {
              return const SkeletonCard.list();
            }
            final count = meals.length > 3 ? 3 : meals.length;
            return SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: count,
                itemBuilder: (_, index) {
                  final meal = meals[index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed('/nutrition'),
                    child: Container(
                      width: 180,
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(.15),
                            theme.colorScheme.primary.withOpacity(.05),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(meal['title'] as String? ?? '',
                              style: theme.textTheme.titleMedium),
                          const Spacer(),
                          Text(meal['time'] as String? ?? ''),
                          Text('${meal['calories']} kcal',
                              style: theme.textTheme.labelSmall),
                        ],
                      ),
                    ).animate().fadeIn().slideX(begin: .08),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _HydrationPreview extends StatelessWidget {
  const _HydrationPreview({required this.controller});

  final HydrationController controller;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: theme.cardColor,
      ),
      child: ValueListenableBuilder<double>(
        valueListenable: controller.intakeLiters,
        builder: (_, intake, __) {
          return ValueListenableBuilder<double>(
            valueListenable: controller.goalLiters,
            builder: (_, goal, __) {
              final progress = (intake / goal).clamp(0.0, 1.2);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(loc.translate('home_hydration_title'),
                                style: theme.textTheme.titleMedium),
                            Text(loc.translate('home_hydration_subtitle'),
                                style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(IconlyLight.activity),
                        onPressed: () =>
                            Navigator.of(context).pushNamed('/hydration'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(100),
                  ).animate().scaleX(alignment: Alignment.centerLeft),
                  const SizedBox(height: 8),
                  Text('${intake.toStringAsFixed(1)} / ${goal.toStringAsFixed(1)} L'),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _CommunityPreview extends StatelessWidget {
  const _CommunityPreview({required this.controller});

  final CommunityController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.translate('home_community_title'),
                      style: theme.textTheme.titleMedium),
                  Text(loc.translate('home_community_subtitle'),
                      style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/community'),
              child: Text(loc.translate('view_all')),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: controller.moments,
          builder: (_, feed, __) {
            if (feed.isEmpty) {
              return const SkeletonCard.list();
            }
            return Column(
              children: feed.take(2).map((moment) {
                return ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24)),
                  tileColor: theme.cardColor,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(moment['image'] as String),
                  ),
                  title: Text(moment['title'] as String? ?? ''),
                  subtitle: Text(moment['summary'] as String? ?? ''),
                  trailing: IconButton(
                    icon: const Icon(IconlyLight.heart),
                    onPressed: () => controller.toggleClap(moment['id'] as String),
                  ),
                  onTap: () => Navigator.of(context).pushNamed('/community'),
                ).animate().fadeIn().slideX(begin: .08);
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _PerformancePreview extends StatelessWidget {
  const _PerformancePreview({required this.controller});

  final PerformanceController controller;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.translate('home_performance_title'),
                      style: theme.textTheme.titleMedium),
                  Text(loc.translate('home_performance_subtitle'),
                      style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/performance'),
              child: Text(loc.translate('view_all')),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<double>(
          valueListenable: controller.readinessScore,
          builder: (_, score, __) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(.1),
                    theme.colorScheme.primary.withOpacity(.3),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(loc.translate('readiness_score'),
                        style: theme.textTheme.bodyMedium),
                  ),
                  AnimatedSwitcher(
                    duration: 300.ms,
                    child: Text(
                      score.toStringAsFixed(1),
                      key: ValueKey(score.toStringAsFixed(1)),
                      style: theme.textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn();
          },
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: controller.sessions,
          builder: (_, sessions, __) {
            if (sessions.isEmpty) {
              return const SkeletonCard.list();
            }
            return SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: theme.cardColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(session['title'] as String? ?? ''),
                        const Spacer(),
                        Text(session['duration'] as String? ?? ''),
                      ],
                    ),
                  ).animate().fadeIn().slideX(begin: .08);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _RecoveryPreview extends StatelessWidget {
  const _RecoveryPreview({required this.controller});

  final RecoveryController controller;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.translate('home_recovery_title'),
                      style: theme.textTheme.titleMedium),
                  Text(loc.translate('home_recovery_subtitle'),
                      style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/recovery'),
              child: Text(loc.translate('view_all')),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: controller.protocols,
          builder: (_, protocols, __) {
            if (protocols.isEmpty) {
              return const SkeletonCard.list();
            }
            return Column(
              children: protocols.take(2).map((protocol) {
                final done = protocol['completed'] == true;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: theme.cardColor,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(protocol['title'] as String? ?? ''),
                            Text(protocol['description'] as String? ?? ''),
                          ],
                        ),
                      ),
                      Icon(
                        done ? IconlyBold.tick_square : IconlyLight.play,
                        color: done
                            ? theme.colorScheme.primary
                            : theme.colorScheme.secondary,
                      ),
                    ],
                  ),
                ).animate().fadeIn();
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _MissionPreview extends StatelessWidget {
  const _MissionPreview({required this.controller});

  final MissionController controller;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.translate('home_mission_title'),
                      style: theme.textTheme.titleMedium),
                  Text(loc.translate('home_mission_subtitle'),
                      style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/mission'),
              child: Text(loc.translate('view_all')),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<double>(
          valueListenable: controller.readiness,
          builder: (_, readiness, __) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: LinearGradient(colors: [
                  theme.colorScheme.primary.withOpacity(.12),
                  theme.colorScheme.primary.withOpacity(.28),
                ]),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: readiness,
                          strokeWidth: 6,
                          backgroundColor:
                              theme.colorScheme.onPrimary.withOpacity(.1),
                        ),
                        Center(
                          child: Text('${(readiness * 100).round()}%',
                              style: theme.textTheme.titleMedium),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(loc.translate('mission_readiness'),
                        style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
            ).animate().fadeIn().scale(begin: const Offset(.98, .98));
          },
        ),
        const SizedBox(height: 16),
        Text(loc.translate('mission_pillars'),
            style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: controller.pillars,
          builder: (_, pillars, __) {
            if (pillars.isEmpty) {
              return Wrap(
                spacing: 8,
                children: const [SkeletonChip(), SkeletonChip(), SkeletonChip()],
              );
            }
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: pillars.map((pillar) {
                final selected = pillar['active'] == true;
                return ChoiceChip(
                  label: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(pillar['title'] as String),
                      Text(pillar['subtitle'] as String,
                          style: theme.textTheme.labelSmall),
                    ],
                  ),
                  selected: selected,
                  onSelected: (_) =>
                      controller.togglePillar(pillar['id'] as String),
                ).animate().fadeIn();
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(loc.translate('mission_rituals'),
            style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: controller.rituals,
          builder: (_, rituals, __) {
            if (rituals.isEmpty) {
              return const SkeletonCard.list();
            }
            return Column(
              children: rituals.take(3).map((ritual) {
                final done = ritual['completed'] == true;
                return GestureDetector(
                  onTap: () => controller.completeRitual(ritual['id'] as String),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: theme.cardColor,
                    ),
                    child: Row(
                      children: [
                        Icon(done ? Icons.check_circle : Icons.circle_outlined,
                            color: done
                                ? theme.colorScheme.primary
                                : theme.disabledColor),
                        const SizedBox(width: 12),
                        Expanded(child: Text(ritual['title'] as String)),
                        Text(ritual['duration'] as String,
                            style: theme.textTheme.labelSmall),
                      ],
                    ),
                  ).animate().fadeIn().slideX(begin: .08),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(loc.translate('mission_timeline'),
            style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: controller.missions,
          builder: (_, missions, __) {
            if (missions.isEmpty) {
              return const SkeletonCard.large();
            }
            return SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: missions.length,
                itemBuilder: (_, index) {
                  final mission = missions[index];
                  final progress = mission['progress'] as double? ?? .5;
                  return Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(colors: [
                        (mission['color'] as Color?) ??
                            theme.colorScheme.primary.withOpacity(.2),
                        theme.colorScheme.primary.withOpacity(.15),
                      ]),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mission['title'] as String,
                            style: theme.textTheme.titleSmall),
                        const SizedBox(height: 6),
                        Text(mission['summary'] as String,
                            style: theme.textTheme.bodySmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const Spacer(),
                        LinearProgressIndicator(value: progress),
                        const SizedBox(height: 6),
                        Text('${(progress * 100).round()}% · ${mission['eta']}',
                            style: theme.textTheme.labelSmall),
                      ],
                    ),
                  ).animate().fadeIn().slideX(begin: .1 * index);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _CompanionPreview extends StatelessWidget {
  const _CompanionPreview({required this.controller});

  final CompanionController controller;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loc.translate('home_companion_title'),
                      style: theme.textTheme.titleMedium),
                  Text(loc.translate('home_companion_subtitle'),
                      style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/companion'),
              child: Text(loc.translate('view_all')),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: controller.messages,
          builder: (_, messages, __) {
            if (messages.isEmpty) {
              return const SkeletonCard.large();
            }
            Map<String, dynamic>? latestAi;
            for (final message in messages.reversed) {
              if (message['role'] == 'ai') {
                latestAi = message;
                break;
              }
            }
            latestAi ??= messages.last;
            final time = latestAi['time'] is DateTime
                ? TimeOfDay.fromDateTime(latestAi['time'] as DateTime)
                    .format(context)
                : '';
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                color: theme.colorScheme.surfaceVariant.withOpacity(.3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(latestAi['text'] as String,
                      style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 8),
                  Text(time, style: theme.textTheme.labelSmall),
                ],
              ),
            ).animate().fadeIn().scale(begin: const Offset(.98, .98));
          },
        ),
        const SizedBox(height: 12),
        Text(loc.translate('ai_companion_prompts'),
            style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        ValueListenableBuilder<List<Map<String, dynamic>>>(
          valueListenable: controller.prompts,
          builder: (_, prompts, __) {
            if (prompts.isEmpty) {
              return Wrap(
                spacing: 8,
                children: const [SkeletonChip(), SkeletonChip()],
              );
            }
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: prompts.map((prompt) {
                final body = prompt['body'] as String;
                final emoji = prompt['emoji'] as String? ?? '';
                final label = prompt['label'] as String? ?? '';
                final display = emoji.isNotEmpty ? '$emoji $label' : label;
                return ActionChip(
                  label: Text(display),
                  onPressed: () {
                    controller.usePrompt(body);
                    Navigator.of(context).pushNamed('/companion');
                  },
                ).animate().fadeIn();
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
