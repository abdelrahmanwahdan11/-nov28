import 'dart:async';

import 'package:flutter/material.dart';

import '../core/mock_data/mock_data.dart';

class DashboardController {
  final ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());
  final ValueNotifier<List<Map<String, dynamic>>> ringSegments =
      ValueNotifier(List<Map<String, dynamic>>.from(MockData.vitals));
  final ValueNotifier<bool> loading = ValueNotifier(false);

  Future<void> refresh() async {
    loading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    selectedDate.value = DateTime.now();
    loading.value = false;
  }
}
