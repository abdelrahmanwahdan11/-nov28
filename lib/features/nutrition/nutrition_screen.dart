import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';
import '../../widgets/skeletons.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final controller = scope.nutritionController;
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('nutrition_lab')),
        actions: [
          IconButton(
            icon: const Icon(IconlyLight.activity),
            tooltip: loc.translate('hydration_hub'),
            onPressed: () => Navigator.of(context).pushNamed('/hydration'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            ValueListenableBuilder<Map<String, dynamic>>(
              valueListenable: controller.macroSummary,
              builder: (_, macros, __) {
                return _MacroOverview(macros: macros);
              },
            ),
            const SizedBox(height: 24),
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
                  onPressed: () => controller.setDay(0),
                  child: Text(loc.translate('view_all')),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<bool>(
              valueListenable: controller.isLoading,
              builder: (_, loading, __) {
                if (loading) {
                  return Column(
                    children: List.generate(
                      2,
                      (index) => const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: SkeletonCard.list(),
                      ),
                    ),
                  );
                }
                return ValueListenableBuilder<List<Map<String, dynamic>>>(
                  valueListenable: controller.mealPlans,
                  builder: (_, meals, __) {
                    return Column(
                      children: [
                        for (int i = 0; i < meals.length; i++)
                          _MealCard(
                            data: meals[i],
                            onFavorite: () => controller
                                .toggleFavorite(meals[i]['id'] as String),
                            delay: (i * 80).ms,
                          ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(loc.translate('snack_queue'),
                    style: theme.textTheme.titleMedium),
                const Spacer(),
                const AiInfoButton(),
              ],
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.snacks,
              builder: (_, snacks, __) {
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: snacks
                      .map(
                        (snack) => FilterChip(
                          label: Text(snack['title'] as String? ?? ''),
                          avatar: Icon(
                            snack['completed'] == true
                                ? IconlyBold.tick_square
                                : IconlyLight.paper,
                          ),
                          selected: snack['completed'] == true,
                          onSelected: (_) => controller
                              .toggleSnack(snack['id'] as String),
                        ).animate().fadeIn().scale(),
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

class _MacroOverview extends StatelessWidget {
  const _MacroOverview({required this.macros});

  final Map<String, dynamic> macros;

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
            theme.colorScheme.primary.withOpacity(.2),
            theme.colorScheme.tertiaryContainer
                .withOpacity(theme.brightness == Brightness.dark ? .3 : .15),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  loc.translate('macro_breakdown'),
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const AiInfoButton(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${loc.translate('calories_today')} ${((macros['calories'] as num?) ?? 0).toStringAsFixed(0)} kcal',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (final entry in ['carbs', 'protein', 'fat', 'fiber'])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(
                            begin: 0,
                            end: ((macros[entry] as num?) ?? 0) / 100,
                          ),
                          duration: 500.ms,
                          builder: (_, value, child) => LinearProgressIndicator(
                            value: value.clamp(0.0, 1.0),
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(entry.toUpperCase(),
                            style: theme.textTheme.labelSmall),
                        Text('${macros[entry]}%',
                            style: theme.textTheme.titleMedium),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: .08);
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({
    required this.data,
    required this.onFavorite,
    required this.delay,
  });

  final Map<String, dynamic> data;
  final VoidCallback onFavorite;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: theme.cardColor,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 80,
              width: 80,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: data['id'],
                    child: Image.network(
                      data['image'] as String,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(.0),
                            Colors.black.withOpacity(.4),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['title'] as String? ?? '',
                    style: theme.textTheme.titleMedium),
                Text(data['time'] as String? ?? '',
                    style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: [
                    Text('Carb ${(data['carbs'] as num?) ?? 0}g',
                        style: theme.textTheme.labelSmall),
                    Text('Protein ${(data['protein'] as num?) ?? 0}g',
                        style: theme.textTheme.labelSmall),
                    Text('Fat ${(data['fat'] as num?) ?? 0}g',
                        style: theme.textTheme.labelSmall),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              data['favorite'] == true
                  ? IconlyBold.heart
                  : IconlyLight.heart,
              color:
                  data['favorite'] == true ? theme.colorScheme.primary : null,
            ),
            tooltip: loc.translate('add_compare'),
            onPressed: onFavorite,
          ),
        ],
      ),
    ).animate(delay: delay).fadeIn().slideX(begin: .08);
  }
}
