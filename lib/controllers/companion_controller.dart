import 'package:flutter/material.dart';

import '../core/mock_data/mock_data.dart';

class CompanionController extends ChangeNotifier {
  CompanionController() {
    _seed = DateTime.now().millisecondsSinceEpoch % 991;
    messages.value = [
      {
        'id': 'ai-welcome',
        'role': 'ai',
        'text': MockData.initialCompanionGreeting(_seed),
        'time': DateTime.now().subtract(const Duration(minutes: 2)),
      },
      {
        'id': 'user-intro',
        'role': 'user',
        'text': 'Appreciate the check-in today.',
        'time': DateTime.now().subtract(const Duration(minutes: 1)),
      },
    ];
    refreshPrompts();
  }

  late int _seed;

  final ValueNotifier<List<Map<String, dynamic>>> messages =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<List<Map<String, dynamic>>> prompts =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<bool> isTyping = ValueNotifier<bool>(false);

  void refreshPrompts() {
    prompts.value = MockData.companionPrompts(_seed++);
  }

  Future<void> sendPrompt(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final entry = {
      'id': 'user-${DateTime.now().millisecondsSinceEpoch}',
      'role': 'user',
      'text': trimmed,
      'time': DateTime.now(),
    };
    messages.value = [...messages.value, entry];
    isTyping.value = true;
    final replySeed = _seed++;
    final response = MockData.generateCompanionReply(trimmed, replySeed);
    await Future.delayed(const Duration(milliseconds: 720));
    final reply = {
      'id': 'ai-${DateTime.now().millisecondsSinceEpoch}',
      'role': 'ai',
      'text': response,
      'time': DateTime.now(),
    };
    messages.value = [...messages.value, reply];
    isTyping.value = false;
  }

  Future<void> usePrompt(String value) {
    return sendPrompt(value);
  }

  @override
  void dispose() {
    messages.dispose();
    prompts.dispose();
    isTyping.dispose();
    super.dispose();
  }
}
