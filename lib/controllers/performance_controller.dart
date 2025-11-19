import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/mock_data/mock_data.dart';

class PerformanceController extends ChangeNotifier {
  PerformanceController() {
    refresh();
  }

  final ValueNotifier<List<Map<String, dynamic>>> sessions =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<List<Map<String, dynamic>>> timeline =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<List<Map<String, dynamic>>> mobilityHeat =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<double> readinessScore = ValueNotifier<double>(7.4);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  Future<void> refresh() async {
    isLoading.value = true;
    final seed = DateTime.now().millisecondsSinceEpoch;
    await Future.delayed(const Duration(milliseconds: 520));
    sessions.value = MockData.performanceSessions(seed);
    timeline.value = MockData.performanceTimeline(seed);
    mobilityHeat.value = MockData.mobilityHeat(seed);
    readinessScore.value = (6 + Random(seed).nextDouble() * 3.5);
    isLoading.value = false;
  }

  void toggleSession(String id) {
    sessions.value = sessions.value
        .map(
          (session) => session['id'] == id
              ? {
                  ...session,
                  'completed': !(session['completed'] as bool? ?? false),
                }
              : session,
        )
        .toList();
  }

  void toggleTimeline(String id) {
    timeline.value = timeline.value
        .map(
          (entry) => entry['id'] == id
              ? {
                  ...entry,
                  'expanded': !(entry['expanded'] as bool? ?? false),
                }
              : entry,
        )
        .toList();
  }

  @override
  void dispose() {
    sessions.dispose();
    timeline.dispose();
    mobilityHeat.dispose();
    readinessScore.dispose();
    isLoading.dispose();
    super.dispose();
  }
}
