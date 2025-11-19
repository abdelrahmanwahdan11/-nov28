import 'dart:async';

import 'package:flutter/material.dart';

class CheckupController {
  final ValueNotifier<bool> deviceScanning = ValueNotifier(false);
  final ValueNotifier<double> progress = ValueNotifier(0);
  final ValueNotifier<List<String>> selectedSymptoms = ValueNotifier([]);
  final ValueNotifier<String?> aiSummary = ValueNotifier(null);

  Future<void> runDeviceScan(VoidCallback onComplete) async {
    deviceScanning.value = true;
    progress.value = 0;
    for (int i = 0; i <= 5; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      progress.value = i / 5;
    }
    deviceScanning.value = false;
    onComplete();
  }

  void toggleSymptom(String symptom) {
    final list = List<String>.from(selectedSymptoms.value);
    if (list.contains(symptom)) {
      list.remove(symptom);
    } else {
      list.add(symptom);
    }
    selectedSymptoms.value = list;
  }

  Future<void> runAiSummary() async {
    aiSummary.value = null;
    await Future.delayed(const Duration(milliseconds: 600));
    aiSummary.value =
        'Based on ${selectedSymptoms.value.join(', ')}, focus on rest and hydration.';
  }
}
