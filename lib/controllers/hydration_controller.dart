import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/mock_data/mock_data.dart';

class HydrationController extends ChangeNotifier {
  HydrationController() {
    refresh();
  }

  final ValueNotifier<List<Map<String, dynamic>>> timeline =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<List<Map<String, dynamic>>> reminders =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<double> goalLiters = ValueNotifier<double>(2.4);
  final ValueNotifier<double> intakeLiters = ValueNotifier<double>(1.2);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  double get progress =>
      (intakeLiters.value / goalLiters.value).clamp(0.0, 1.2);

  Future<void> refresh() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 480));
    final seed = DateTime.now().millisecondsSinceEpoch +
        Random().nextInt(77);
    timeline.value = MockData.hydrationTimeline(seed);
    reminders.value = MockData.hydrationReminders(seed);
    goalLiters.value = 2 + Random(seed).nextDouble();
    intakeLiters.value = 1 + Random(seed + 1).nextDouble();
    isLoading.value = false;
    notifyListeners();
  }

  void logIntake(double amount) {
    intakeLiters.value = (intakeLiters.value + amount).clamp(0.0, 4.0);
    final entry = {
      'id': 'log-${DateTime.now().millisecondsSinceEpoch}',
      'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      'amount': amount,
      'mood': 'focus',
    };
    timeline.value = [entry, ...timeline.value];
    notifyListeners();
  }

  void toggleReminder(String id) {
    reminders.value = reminders.value
        .map(
          (reminder) => reminder['id'] == id
              ? {
                  ...reminder,
                  'active': !(reminder['active'] as bool? ?? false),
                }
              : reminder,
        )
        .toList();
  }

  @override
  void dispose() {
    timeline.dispose();
    reminders.dispose();
    goalLiters.dispose();
    intakeLiters.dispose();
    isLoading.dispose();
    super.dispose();
  }
}
