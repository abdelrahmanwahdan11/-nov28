import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';
import '../../widgets/skeletons.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final controller = scope.communityController;
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('community_room')),
        actions: [
          IconButton(
            icon: const Icon(IconlyLight.voice),
            tooltip: loc.translate('coach_room'),
            onPressed: () => Navigator.of(context).pushNamed('/coach'),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            _CircleHero(controller: controller),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(loc.translate('community_pulse'),
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
                  valueListenable: controller.moments,
                  builder: (_, feed, __) {
                    return Column(
                      children: [
                        for (int i = 0; i < feed.length; i++)
                          _MomentCard(
                            data: feed[i],
                            onClap: () => controller
                                .toggleClap(feed[i]['id'] as String),
                            delay: (i * 70).ms,
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
                Text(loc.translate('community_moments'),
                    style: theme.textTheme.titleMedium),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/reports'),
                  child: Text(loc.translate('view_all')),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.mentors,
              builder: (_, mentors, __) {
                return SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: mentors.length,
                    itemBuilder: (_, index) {
                      final mentor = mentors[index];
                      return Container(
                        width: 180,
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          color: theme.cardColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage:
                                  NetworkImage(mentor['avatar'] as String),
                            ),
                            const SizedBox(height: 12),
                            Text(mentor['name'] as String? ?? '',
                                style: theme.textTheme.titleMedium),
                            Text(mentor['role'] as String? ?? '',
                                style: theme.textTheme.bodySmall),
                            const Spacer(),
                            Text('${mentor['streak']} days',
                                style: theme.textTheme.labelSmall),
                          ],
                        ),
                      ).animate().fadeIn().slideX(begin: .1);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MomentCard extends StatelessWidget {
  const _MomentCard({
    required this.data,
    required this.onClap,
    required this.delay,
  });

  final Map<String, dynamic> data;
  final VoidCallback onClap;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withOpacity(.12),
            theme.colorScheme.secondary.withOpacity(.12),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(data['image'] as String),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data['title'] as String? ?? '',
                        style: theme.textTheme.titleMedium),
                    Text(data['time'] as String? ?? '',
                        style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(IconlyLight.heart),
                onPressed: onClap,
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(data['summary'] as String? ?? ''),
          const SizedBox(height: 12),
          Row(
            children: [
              Chip(
                label: Text('${data['claps']} clap'),
              ),
              const SizedBox(width: 8),
              Chip(
                label: Text('${data['comments']} reply'),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: delay).fadeIn().slideY(begin: .06);
  }
}

class _CircleHero extends StatelessWidget {
  const _CircleHero({required this.controller});

  final CommunityController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: controller.circles,
      builder: (_, circles, __) {
        if (circles.isEmpty) {
          return const SkeletonCard.large();
        }
        final featured = circles.first;
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: theme.cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(loc.translate('community_join'),
                  style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(featured['title'] as String? ?? '',
                  style: theme.textTheme.headlineSmall),
              Text(featured['time'] as String? ?? ''),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.toggleCircle(featured['id'] as String),
                child: Text(featured['joined'] == true
                    ? loc.translate('done')
                    : loc.translate('view_circle')),
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: .1);
      },
    );
  }
}
