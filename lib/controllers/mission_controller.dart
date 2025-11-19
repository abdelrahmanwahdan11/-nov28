import 'dart:math';

import 'package:flutter/material.dart';

import '../core/mock_data/mock_data.dart';

class MissionController extends ChangeNotifier {
  MissionController() {
    refresh();
  }

  final ValueNotifier<List<Map<String, dynamic>>> missions =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<List<Map<String, dynamic>>> pillars =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<List<Map<String, dynamic>>> rituals =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<double> readiness = ValueNotifier<double>(.62);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  Future<void> refresh() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 520));
    final seed = DateTime.now().millisecondsSinceEpoch % 997;
    missions.value = MockData.missionTimeline(seed);
    pillars.value = MockData.missionPillars(seed);
    rituals.value = MockData.missionRituals(seed);
    readiness.value = (.55 + Random(seed).nextDouble() * .4).clamp(0.0, 1.0);
    isLoading.value = false;
  }

  void togglePillar(String id) {
    final updated = pillars.value
        .map((pillar) => pillar['id'] == id
            ? {
                ...pillar,
                'active': !(pillar['active'] as bool? ?? false),
              }
            : pillar)
        .toList();
    pillars.value = updated;
  }

  void completeRitual(String id) {
    final updated = rituals.value
        .map((ritual) => ritual['id'] == id
            ? {
                ...ritual,
                'completed': !(ritual['completed'] as bool? ?? false),
              }
            : ritual)
        .toList();
    rituals.value = updated;
  }

  @override
  void dispose() {
    missions.dispose();
    pillars.dispose();
    rituals.dispose();
    readiness.dispose();
    isLoading.dispose();
    super.dispose();
  }
}
