import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';
import '../../widgets/skeletons.dart';

class MomentsScreen extends StatefulWidget {
  const MomentsScreen({super.key});

  @override
  State<MomentsScreen> createState() => _MomentsScreenState();
}

class _MomentsScreenState extends State<MomentsScreen> {
  final TextEditingController _noteController = TextEditingController();
  final List<String> _moods = ['calm', 'focused', 'energized'];
  String _selectedMood = 'calm';

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = ControllerScope.of(context);
    final controller = scope.momentsController;
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('moments_lab')),
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
                return ValueListenableBuilder<double>(
                  valueListenable: controller.moodScore,
                  builder: (_, score, __) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.secondary.withOpacity(.15),
                            theme.colorScheme.primary.withOpacity(.3),
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
                                    Text(loc.translate('moments_mood'),
                                        style: theme.textTheme.titleMedium),
                                    Text(loc.translate('moments_prompt'),
                                        style: theme.textTheme.bodyMedium),
                                  ],
                                ),
                              ),
                              const AiInfoButton(),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AnimatedSwitcher(
                            duration: 320.ms,
                            child: Text(
                              '${(score * 10).toStringAsFixed(1)}/10',
                              key: ValueKey(score.toStringAsFixed(2)),
                              style: theme.textTheme.displaySmall,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: score.clamp(0.0, 1.0),
                            minHeight: 10,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ],
                      ),
                    ).animate().fadeIn().slideY(begin: .1);
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            Text(loc.translate('gratitude_prompt'),
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.prompts,
              builder: (_, prompts, __) {
                if (prompts.isEmpty) {
                  return const SkeletonCard.list();
                }
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: prompts.map((prompt) {
                    return ChoiceChip(
                      label: Text(prompt['title'] as String? ?? ''),
                      selected: prompt == prompts.first,
                      onSelected: (_) => controller.rotatePrompt(),
                    ).animate().fadeIn();
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(loc.translate('add_entry'), style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _moods.map((mood) {
                final translated = loc.translate('mood_$mood');
                return ChoiceChip(
                  label: Text(translated),
                  selected: _selectedMood == mood,
                  onSelected: (_) {
                    setState(() => _selectedMood = mood);
                    controller.setMood(mood);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: loc.translate('moments_prompt'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                controller.addMoment(_selectedMood, _noteController.text);
                _noteController.clear();
              },
              icon: const Icon(IconlyBold.plus),
              label: Text(loc.translate('add_entry')),
            ),
            const SizedBox(height: 24),
            Text(loc.translate('moments_entries'),
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.entries,
              builder: (_, entries, __) {
                if (entries.isEmpty) {
                  return const SkeletonCard.list();
                }
                return Column(
                  children: entries.map((entry) {
                    final favorite = entry['favorite'] == true;
                    final timestamp = entry['timestamp'] as DateTime? ?? DateTime.now();
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('${entry['mood']} · '
                                    '${TimeOfDay.fromDateTime(timestamp).format(context)}'),
                                const Spacer(),
                                IconButton(
                                  icon: Icon(
                                    favorite
                                        ? IconlyBold.heart
                                        : IconlyLight.heart,
                                    color: favorite
                                        ? theme.colorScheme.primary
                                        : theme.iconTheme.color,
                                  ),
                                  onPressed: () => controller
                                      .toggleFavorite(entry['id'] as String),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(entry['note'] as String? ?? ''),
                          ],
                        ),
                      ),
                    ).animate().fadeIn().slideY(begin: .05);
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
