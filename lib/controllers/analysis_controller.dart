import 'dart:async';

import 'package:flutter/material.dart';

import '../core/mock_data/mock_data.dart';

class AnalysisController {
  final tabs = const ['heart_rate', 'blood_pressure', 'spo2', 'blood_sugar'];
  final ValueNotifier<String> selectedTab = ValueNotifier('heart_rate');
  final Map<String, List<Map<String, dynamic>>> _history = {};
  final Map<String, int> _pages = {};
  final StreamController<List<Map<String, dynamic>>> historyStream =
      StreamController.broadcast();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  AnalysisController() {
    loadInitial();
  }

  void dispose() {
    historyStream.close();
  }

  void selectTab(String tab) {
    selectedTab.value = tab;
    if (_history[tab] == null) {
      loadMore();
    } else {
      historyStream.add(_history[tab]!);
    }
  }

  Future<void> loadInitial() async {
    await loadMore();
  }

  Future<void> loadMore() async {
    final tab = selectedTab.value;
    final nextPage = (_pages[tab] ?? 0) + 1;
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 700));
    final newEntries = MockData.historicalVitals(tab, nextPage);
    final existing = _history[tab] ?? [];
    _history[tab] = [...existing, ...newEntries];
    _pages[tab] = nextPage;
    historyStream.add(_history[tab]!);
    isLoading.value = false;
  }
}
