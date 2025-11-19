import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../core/mock_data/mock_data.dart';

class HomeController {
  final ValueNotifier<double> healthScore = ValueNotifier(8.2);
  final ValueNotifier<List<Map<String, dynamic>>> vitals =
      ValueNotifier(List<Map<String, dynamic>>.from(MockData.vitals));
  final ValueNotifier<List<Map<String, String>>> reminders = ValueNotifier([
    {'title': 'Morning meditation', 'time': '08:00'},
    {'title': 'Hydration break', 'time': '11:30'},
    {'title': 'Medication', 'time': '19:00'},
  ]);
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<void> refresh() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 900));
    final random = Random();
    healthScore.value = 6 + random.nextDouble() * 4;
    vitals.value = MockData.vitals.map((e) {
      final base = Map<String, dynamic>.from(e);
      if (base['value'] is num) {
        base['value'] = (base['value'] as num) + random.nextInt(6) - 3;
      }
      return base;
    }).toList();
    isLoading.value = false;
  }
}
