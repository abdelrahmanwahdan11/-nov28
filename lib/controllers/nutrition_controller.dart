import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/mock_data/mock_data.dart';

class NutritionController extends ChangeNotifier {
  NutritionController() {
    refresh();
  }

  final ValueNotifier<List<Map<String, dynamic>>> mealPlans =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<Map<String, dynamic>> macroSummary =
      ValueNotifier<Map<String, dynamic>>({
    'calories': 1800,
    'carbs': 40,
    'protein': 30,
    'fat': 30,
    'fiber': 25,
  });
  final ValueNotifier<List<Map<String, dynamic>>> snacks =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<int> selectedDay = ValueNotifier<int>(0);

  Future<void> refresh() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 520));
    final seed = DateTime.now().millisecondsSinceEpoch +
        Random().nextInt(99);
    mealPlans.value = MockData.mealPlans(seed);
    macroSummary.value = MockData.macroBreakdown(seed);
    snacks.value = MockData.snackIdeas(seed);
    isLoading.value = false;
  }

  void toggleFavorite(String id) {
    final updated = mealPlans.value
        .map(
          (meal) => meal['id'] == id
              ? {
                  ...meal,
                  'favorite': !(meal['favorite'] as bool? ?? false),
                }
              : meal,
        )
        .toList();
    mealPlans.value = updated;
  }

  void toggleSnack(String id) {
    final updated = snacks.value
        .map(
          (snack) => snack['id'] == id
              ? {
                  ...snack,
                  'completed': !(snack['completed'] as bool? ?? false),
                }
              : snack,
        )
        .toList();
    snacks.value = updated;
  }

  void setDay(int index) {
    selectedDay.value = index;
  }

  @override
  void dispose() {
    mealPlans.dispose();
    macroSummary.dispose();
    snacks.dispose();
    isLoading.dispose();
    selectedDay.dispose();
    super.dispose();
  }
}
