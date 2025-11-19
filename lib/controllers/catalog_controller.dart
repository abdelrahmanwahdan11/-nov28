import 'dart:async';

import 'package:flutter/material.dart';

import '../core/mock_data/mock_data.dart';

class CatalogController {
  final ValueNotifier<List<Map<String, dynamic>>> items = ValueNotifier([]);
  final ValueNotifier<bool> loading = ValueNotifier(false);
  final ValueNotifier<bool> grid = ValueNotifier(true);
  final ValueNotifier<Set<String>> compareSelection = ValueNotifier({});
  final ValueNotifier<String> query = ValueNotifier('');
  Timer? _debounce;
  int _page = 0;
  bool _reachedEnd = false;

  CatalogController() {
    loadMore();
  }

  void toggleLayout() => grid.value = !grid.value;

  void toggleFavorite(String id) {
    final idx = items.value.indexWhere((element) => element['id'] == id);
    if (idx == -1) return;
    final updated = List<Map<String, dynamic>>.from(items.value);
    updated[idx] = Map<String, dynamic>.from(updated[idx])
      ..['isFavorite'] = !(updated[idx]['isFavorite'] as bool);
    items.value = updated;
  }

  void onSearchChanged(String value) {
    query.value = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      refresh();
    });
  }

  Future<void> refresh() async {
    items.value = [];
    _page = 0;
    _reachedEnd = false;
    await loadMore();
  }

  Future<void> loadMore() async {
    if (_reachedEnd || loading.value) return;
    loading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    _page += 1;
    final newItems = MockData.pagedCatalog(_page)
        .where((element) => element['title']
            .toString()
            .toLowerCase()
            .contains(query.value.toLowerCase()))
        .toList();
    if (newItems.isEmpty) {
      _reachedEnd = true;
    }
    items.value = [...items.value, ...newItems];
    loading.value = false;
  }

  void toggleCompare(String id) {
    final set = Set<String>.from(compareSelection.value);
    if (set.contains(id)) {
      set.remove(id);
    } else if (set.length < 3) {
      set.add(id);
    }
    compareSelection.value = set;
  }
}
