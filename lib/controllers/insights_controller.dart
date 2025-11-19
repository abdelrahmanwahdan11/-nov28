import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/mock_data/mock_data.dart';

class InsightsController extends ChangeNotifier {
  InsightsController() {
    refresh();
  }

  final ValueNotifier<List<Map<String, dynamic>>> insights =
      ValueNotifier<List<Map<String, dynamic>>>(
          const <Map<String, dynamic>>[]);
  final ValueNotifier<List<Map<String, dynamic>>> journey =
      ValueNotifier<List<Map<String, dynamic>>>(
          const <Map<String, dynamic>>[]);
  final ValueNotifier<List<Map<String, dynamic>>> coachPlan =
      ValueNotifier<List<Map<String, dynamic>>>(
          const <Map<String, dynamic>>[]);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<int> selectedMood = ValueNotifier<int>(0);
  final StreamController<double> progressStream =
      StreamController<double>.broadcast();

  Future<void> refresh() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 480));
    final seedShift = Random().nextInt(99);
    insights.value = MockData.wellnessInsights(seedShift);
    journey.value = MockData.journeyMilestones(seedShift);
    coachPlan.value = MockData.coachPlan(seedShift);
    final progress = .58 + Random(seedShift).nextDouble() * .35;
    progressStream.add(progress.clamp(0.0, 1.0));
    isLoading.value = false;
  }

  void toggleFavorite(String id) {
    final updated = insights.value
        .map((entry) => entry['id'] == id
            ? {
                ...entry,
                'favorite': !(entry['favorite'] as bool? ?? false),
              }
            : entry)
        .toList();
    insights.value = updated;
  }

  void setMood(int index) {
    selectedMood.value = index;
  }

  void completePlanStep(String id) {
    final updated = coachPlan.value
        .map((plan) => plan['id'] == id
            ? {
                ...plan,
                'completed': !(plan['completed'] as bool? ?? false),
              }
            : plan)
        .toList();
    coachPlan.value = updated;
  }

  @override
  void dispose() {
    progressStream.close();
    insights.dispose();
    journey.dispose();
    coachPlan.dispose();
    isLoading.dispose();
    selectedMood.dispose();
    super.dispose();
  }
}
