import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/mock_data/mock_data.dart';

class MomentsController extends ChangeNotifier {
  MomentsController() {
    refresh();
  }

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Map<String, dynamic>>> entries =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<List<Map<String, dynamic>>> prompts =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<double> moodScore = ValueNotifier<double>(0.72);
  final ValueNotifier<String> selectedMood = ValueNotifier<String>('calm');

  Future<void> refresh() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 420));
    final seed = DateTime.now().millisecondsSinceEpoch + Random().nextInt(60);
    entries.value = MockData.momentEntries(seed);
    prompts.value = MockData.momentPrompts(seed);
    moodScore.value = 0.65 + Random().nextDouble() * 0.25;
    isLoading.value = false;
  }

  void addMoment(String mood, String note) {
    if (note.trim().isEmpty) return;
    final newEntry = {
      'id': 'moment-${DateTime.now().millisecondsSinceEpoch}',
      'mood': mood,
      'note': note.trim(),
      'timestamp': DateTime.now(),
      'favorite': false,
    };
    entries.value = [newEntry, ...entries.value];
    moodScore.value = (moodScore.value + 0.05).clamp(0.0, 1.0);
  }

  void toggleFavorite(String id) {
    entries.value = entries.value
        .map(
          (entry) => entry['id'] == id
              ? {
                  ...entry,
                  'favorite': !(entry['favorite'] as bool? ?? false),
                }
              : entry,
        )
        .toList();
  }

  void rotatePrompt() {
    if (prompts.value.isEmpty) return;
    final updated = List<Map<String, dynamic>>.from(prompts.value);
    final first = updated.removeAt(0);
    updated.add(first);
    prompts.value = updated;
  }

  void setMood(String mood) {
    selectedMood.value = mood;
  }

  @override
  void dispose() {
    isLoading.dispose();
    entries.dispose();
    prompts.dispose();
    moodScore.dispose();
    selectedMood.dispose();
    super.dispose();
  }
}
