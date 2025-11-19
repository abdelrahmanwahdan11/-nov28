import 'dart:async';

import 'package:flutter/material.dart';

import '../core/mock_data/mock_data.dart';

class ReportsController {
  final ValueNotifier<List<Map<String, dynamic>>> reports = ValueNotifier([]);
  final ValueNotifier<bool> loading = ValueNotifier(false);
  int _page = 0;
  bool _reachedEnd = false;

  ReportsController() {
    loadMore();
  }

  Future<void> refresh() async {
    reports.value = [];
    _page = 0;
    _reachedEnd = false;
    await loadMore();
  }

  Future<void> loadMore() async {
    if (_reachedEnd || loading.value) return;
    loading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    _page += 1;
    final newReports = MockData.pagedReports(_page);
    if (newReports.isEmpty) {
      _reachedEnd = true;
    }
    reports.value = [...reports.value, ...newReports];
    loading.value = false;
  }
}
