import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../core/mock_data/mock_data.dart';

class WellnessController {
  WellnessController() {
    _loadInitial();
    _startBreathingLoop();
  }

  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<List<Map<String, dynamic>>> journeyMoments =
      ValueNotifier(const []);
  final ValueNotifier<List<Map<String, dynamic>>> mindfulnessSessions =
      ValueNotifier(const []);
  final ValueNotifier<List<Map<String, dynamic>>> sleepTimeline =
      ValueNotifier(const []);
  final ValueNotifier<List<Map<String, dynamic>>> boosters =
      ValueNotifier(const []);
  final ValueNotifier<String> selectedMood = ValueNotifier('calm');

  final StreamController<double> breathingProgressController =
      StreamController<double>.broadcast();

  Timer? _breathingTimer;

  void _loadInitial() {
    journeyMoments.value = MockData.wellnessJourney();
    mindfulnessSessions.value = MockData.mindfulnessSessions();
    sleepTimeline.value = MockData.sleepCycles();
    boosters.value = MockData.dailyBoosters();
  }

  Future<void> refreshAll() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    _loadInitial();
    selectedMood.value = ['calm', 'focused', 'energized'][Random().nextInt(3)];
    isLoading.value = false;
  }

  void setMood(String mood) => selectedMood.value = mood;

  void toggleBooster(String id) {
    boosters.value = boosters.value
        .map((booster) => booster['id'] == id
            ? {
                ...booster,
                'completed': !(booster['completed'] as bool? ?? false),
              }
            : booster)
        .toList();
  }

  void completeSession(String id) {
    mindfulnessSessions.value = mindfulnessSessions.value
        .map((session) => session['id'] == id
            ? {
                ...session,
                'completed': true,
              }
            : session)
        .toList();
  }

  void _startBreathingLoop() {
    _breathingTimer?.cancel();
    var tick = 0.0;
    _breathingTimer =
        Timer.periodic(const Duration(milliseconds: 80), (timer) {
      tick += .08;
      final value = (sin(tick) + 1) / 2;
      breathingProgressController.add(value);
    });
  }

  void dispose() {
    _breathingTimer?.cancel();
    breathingProgressController.close();
  }
}
