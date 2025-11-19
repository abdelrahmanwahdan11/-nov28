import 'package:flutter/material.dart';

class CompareController {
  final ValueNotifier<List<Map<String, dynamic>>> selectedItems =
      ValueNotifier([]);

  void setItems(List<Map<String, dynamic>> items) {
    selectedItems.value = items.take(3).toList();
  }

  void removeAt(int index) {
    final list = List<Map<String, dynamic>>.from(selectedItems.value);
    if (index < list.length) {
      list.removeAt(index);
      selectedItems.value = list;
    }
  }
}
