import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';
import '../../widgets/skeletons.dart';

class CareScreen extends StatelessWidget {
  const CareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final controller = scope.careController;
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final channels = [
      ('video', IconlyLight.video, loc.translate('care_channel_video')),
      ('chat', IconlyLight.chat, loc.translate('care_channel_chat')),
      ('visit', IconlyLight.home, loc.translate('care_channel_visit')),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('care_center')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refresh,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(loc.translate('care_team'),
                      style: theme.textTheme.titleMedium),
                ),
                const AiInfoButton(),
              ],
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.careTeam,
              builder: (_, members, __) {
                if (members.isEmpty) {
                  return const SkeletonCard.list();
                }
                return Column(
                  children: members
                      .map(
                        (member) => Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(18),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(member['avatar'] as String),
                            ),
                            title: Text(member['name'] as String? ?? ''),
                            subtitle: Text(member['role'] as String? ?? ''),
                            trailing: IconButton(
                              icon: Icon(
                                (member['favorite'] as bool? ?? false)
                                    ? IconlyBold.heart
                                    : IconlyLight.heart,
                                color: theme.colorScheme.primary,
                              ),
                              onPressed: () => controller
                                  .toggleFavorite(member['id'] as String),
                            ),
                          ),
                        ).animate().fadeIn().slideX(begin: .08),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(loc.translate('care_requests'),
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ValueListenableBuilder<String>(
              valueListenable: controller.selectedChannel,
              builder: (_, selected, __) {
                return Wrap(
                  spacing: 12,
                  children: channels
                      .map(
                        (channel) => ChoiceChip(
                          avatar: Icon(channel.$2,
                              size: 16,
                              color: selected == channel.$1
                                  ? Colors.white
                                  : theme.colorScheme.primary),
                          label: Text(channel.$3),
                          selected: selected == channel.$1,
                          onSelected: (_) => controller.setChannel(channel.$1),
                        ).animate().scale(),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.tickets,
              builder: (_, tickets, __) {
                if (tickets.isEmpty) {
                  return const SkeletonCard.list();
                }
                return Column(
                  children: tickets
                      .map(
                        (ticket) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            color: theme.cardColor,
                            border: Border.all(
                              color: (ticket['status'] == 'closed'
                                      ? Colors.green
                                      : theme.colorScheme.primary)
                                  .withOpacity(.25),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(ticket['title'] as String? ?? '',
                                        style: theme.textTheme.titleMedium),
                                  ),
                                  Text(ticket['status'] == 'closed'
                                      ? loc.translate('care_ticket_closed')
                                      : loc.translate('care_ticket_open')),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(ticket['updated'] as String? ?? ''),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  OutlinedButton(
                                    onPressed: () => controller
                                        .closeTicket(ticket['id'] as String),
                                    child: Text(loc.translate('done')),
                                  ),
                                  const SizedBox(width: 12),
                                  Text('${ticket['channel']} · ${ticket['eta']}'),
                                ],
                              ),
                            ],
                          ),
                        ).animate().fadeIn().slideY(begin: .08),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(loc.translate('care_plan'),
                      style: theme.textTheme.titleMedium),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/companion'),
                  child: Text(loc.translate('care_connect_cta')),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.carePlan,
              builder: (_, plan, __) {
                if (plan.isEmpty) {
                  return const SkeletonCard.list();
                }
                return Column(
                  children: plan
                      .map(
                        (step) => ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          tileColor: theme.cardColor,
                          leading: Checkbox(
                            value: step['completed'] == true,
                            onChanged: (_) => controller
                                .togglePlanStep(step['id'] as String),
                          ),
                          title: Text(step['title'] as String? ?? ''),
                          subtitle: Text(step['detail'] as String? ?? ''),
                          trailing: const Icon(IconlyLight.arrow_right_circle),
                        ).animate().fadeIn().slideX(begin: -.08),
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
