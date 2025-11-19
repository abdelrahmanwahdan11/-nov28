import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';
import '../../widgets/skeletons.dart';

class RecoveryScreen extends StatelessWidget {
  const RecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ControllerScope.of(context).recoveryController;
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('recovery_room')),
        actions: const [AiInfoButton()],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            ValueListenableBuilder<double>(
              valueListenable: controller.resetScore,
              builder: (_, score, __) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    color: theme.colorScheme.secondaryContainer
                        .withOpacity(theme.brightness == Brightness.dark ? .2 : .35),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(loc.translate('nervous_system'),
                                style: theme.textTheme.titleMedium),
                            Text(loc.translate('home_recovery_subtitle'),
                                style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: 350.ms,
                        transitionBuilder: (child, anim) =>
                            ScaleTransition(scale: anim, child: child),
                        child: Text(
                          score.toStringAsFixed(1),
                          key: ValueKey(score.toStringAsFixed(1)),
                          style: theme.textTheme.displaySmall,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: .08);
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(loc.translate('recovery_protocols'),
                      style: theme.textTheme.titleMedium),
                ),
                IconButton(
                  icon: const Icon(IconlyLight.play),
                  onPressed: controller.refresh,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.protocols,
              builder: (_, items, __) {
                if (items.isEmpty) {
                  return const SkeletonCard.list();
                }
                return Column(
                  children: items.map((protocol) {
                    final done = protocol['completed'] == true;
                    return AnimatedContainer(
                      duration: 280.ms,
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        color: theme.cardColor,
                        border: Border.all(
                          color: done
                              ? theme.colorScheme.primary
                              : Colors.transparent,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(protocol['title'] as String? ?? ''),
                        subtitle: Text(protocol['description'] as String? ?? ''),
                        trailing: IconButton(
                          icon: Icon(
                            done
                                ? IconlyBold.tick_square
                                : IconlyLight.tick_square,
                          ),
                          onPressed: () => controller
                              .toggleProtocol(protocol['id'] as String),
                        ),
                      ),
                    ).animate().fadeIn();
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(loc.translate('soothing_moments'),
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.calmingMoments,
              builder: (_, moments, __) {
                if (moments.isEmpty) {
                  return const SkeletonCard.list();
                }
                return SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: moments.length,
                    itemBuilder: (context, index) {
                      final moment = moments[index];
                      final favorite = moment['favorite'] == true;
                      return Container(
                        width: 200,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          image: DecorationImage(
                            image: NetworkImage(moment['image'] as String),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(.35),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(moment['title'] as String? ?? '',
                                style: theme.textTheme.titleLarge
                                    ?.copyWith(color: Colors.white)),
                            Text(moment['summary'] as String? ?? '',
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: Colors.white70)),
                            const Spacer(),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                onPressed: () => controller
                                    .toggleMoment(moment['id'] as String),
                                icon: Icon(
                                  favorite
                                      ? IconlyBold.heart
                                      : IconlyLight.heart,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().slideX(begin: .08);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(loc.translate('breath_sequences'),
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.breathStacks,
              builder: (_, stacks, __) {
                if (stacks.isEmpty) {
                  return const SkeletonCard.list();
                }
                return Wrap(
                  spacing: 12,
                  children: stacks.map((stack) {
                    final done = stack['completed'] == true;
                    return FilterChip(
                      label: Text(stack['title'] as String? ?? ''),
                      selected: done,
                      onSelected: (_) =>
                          controller.toggleBreath(stack['id'] as String),
                    ).animate().scale();
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
