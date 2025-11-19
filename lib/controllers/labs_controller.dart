import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/mock_data/mock_data.dart';

class LabsController extends ChangeNotifier {
  LabsController() {
    refresh();
  }

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Map<String, dynamic>>> upcomingTests =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<List<Map<String, dynamic>>> recentResults =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<List<Map<String, dynamic>>> sampleKits =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<List<Map<String, dynamic>>> timeline =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<String> selectedFilter = ValueNotifier<String>('all');

  Future<void> refresh() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 520));
    final seed = DateTime.now().millisecondsSinceEpoch + Random().nextInt(77);
    upcomingTests.value = MockData.labOrders(seed);
    recentResults.value = MockData.labResults(seed);
    sampleKits.value = MockData.labKits(seed);
    timeline.value = MockData.labTimeline(seed);
    isLoading.value = false;
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void toggleKitStatus(String id) {
    final updated = sampleKits.value
        .map(
          (kit) => kit['id'] == id
              ? {
                  ...kit,
                  'completed': !(kit['completed'] as bool? ?? false),
                }
              : kit,
        )
        .toList();
    sampleKits.value = updated;
  }

  void acknowledgeResult(String id) {
    final updated = recentResults.value
        .map(
          (result) => result['id'] == id
              ? {
                  ...result,
                  'acknowledged': !(result['acknowledged'] as bool? ?? false),
                }
              : result,
        )
        .toList();
    recentResults.value = updated;
  }

  @override
  void dispose() {
    isLoading.dispose();
    upcomingTests.dispose();
    recentResults.dispose();
    sampleKits.dispose();
    timeline.dispose();
    selectedFilter.dispose();
    super.dispose();
  }
}
