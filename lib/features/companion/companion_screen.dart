import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:iconly/iconly.dart';

import '../../controller_scope.dart';
import '../../controllers/companion_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../widgets/ai_info_button.dart';
import '../../widgets/skeletons.dart';

class CompanionScreen extends StatefulWidget {
  const CompanionScreen({super.key});

  @override
  State<CompanionScreen> createState() => _CompanionScreenState();
}

class _CompanionScreenState extends State<CompanionScreen> {
  late final TextEditingController _textController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send(CompanionController controller) async {
    final text = _textController.text;
    if (text.trim().isEmpty) return;
    _textController.clear();
    await controller.sendPrompt(text);
    _scrollToEnd();
  }

  void _scrollToEnd() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: 350.ms,
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ControllerScope.of(context).companionController;
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('companion_room')),
        actions: const [AiInfoButton()],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(loc.translate('ai_companion_prompts'),
                          style: theme.textTheme.titleMedium),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: controller.refreshPrompts,
                    ),
                  ],
                ),
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
                            _scrollToEnd();
                          },
                        ).animate().fadeIn();
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: controller.messages,
              builder: (_, messages, __) {
                if (messages.isEmpty) {
                  return const Center(child: SkeletonCard.large());
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(24),
                  itemCount: messages.length,
                  itemBuilder: (_, index) {
                    final message = messages[index];
                    final isAi = message['role'] == 'ai';
                    final time = message['time'] is DateTime
                        ? TimeOfDay.fromDateTime(message['time'] as DateTime)
                            .format(context)
                        : '';
                    return Align(
                      alignment:
                          isAi ? Alignment.centerLeft : Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        constraints: const BoxConstraints(maxWidth: 320),
                        decoration: BoxDecoration(
                          color: isAi
                              ? theme.colorScheme.surfaceVariant.withOpacity(.4)
                              : theme.colorScheme.primary.withOpacity(.2),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(isAi ? 8 : 28),
                            topRight: Radius.circular(isAi ? 28 : 8),
                            bottomLeft: const Radius.circular(28),
                            bottomRight: const Radius.circular(28),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(message['text'] as String),
                            const SizedBox(height: 6),
                            Text(time, style: theme.textTheme.labelSmall),
                          ],
                        ),
                      ).animate().fadeIn().slideX(begin: isAi ? -.08 : .08),
                    );
                  },
                );
              },
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: controller.isTyping,
            builder: (_, typing, __) {
              if (!typing) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 6,
                      width: 6,
                      child: CircularProgressIndicator(strokeWidth: 1.5),
                    ),
                    const SizedBox(width: 8),
                    Text(loc.translate('ai_companion_typing')),
                  ],
                ).animate().fadeIn(),
              );
            },
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(IconlyLight.edit),
                        hintText: loc.translate('ai_companion_prompt_hint'),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      onSubmitted: (_) => _send(controller),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _send(controller),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                    ),
                    child: Text(loc.translate('send')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
