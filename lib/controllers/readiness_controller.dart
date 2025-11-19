import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/mock_data/mock_data.dart';

class ReadinessController extends ChangeNotifier {
  ReadinessController() {
    refresh();
  }

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<Map<String, dynamic>> orbit =
      ValueNotifier<Map<String, dynamic>>({});
  final ValueNotifier<List<Map<String, dynamic>>> alerts =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<List<Map<String, dynamic>>> drills =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<List<Map<String, dynamic>>> guardians =
      ValueNotifier<List<Map<String, dynamic>>>(const []);

  Future<void> refresh() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 460));
    final seed = DateTime.now().millisecondsSinceEpoch + Random().nextInt(99);
    orbit.value = MockData.readinessOrbit(seed);
    alerts.value = MockData.readinessAlerts(seed);
    drills.value = MockData.readinessDrills(seed);
    guardians.value = MockData.guardianContacts(seed);
    isLoading.value = false;
  }

  void acknowledgeAlert(String id) {
    alerts.value = alerts.value
        .map(
          (alert) => alert['id'] == id
              ? {
                  ...alert,
                  'acknowledged': !(alert['acknowledged'] as bool? ?? false),
                }
              : alert,
        )
        .toList();
  }

  void toggleDrill(String id) {
    drills.value = drills.value
        .map(
          (drill) => drill['id'] == id
              ? {
                  ...drill,
                  'completed': !(drill['completed'] as bool? ?? false),
                }
              : drill,
        )
        .toList();
  }

  void rotateGuardians() {
    if (guardians.value.length < 2) return;
    final list = List<Map<String, dynamic>>.from(guardians.value);
    final first = list.removeAt(0);
    list.add(first);
    guardians.value = list;
  }

  @override
  void dispose() {
    isLoading.dispose();
    orbit.dispose();
    alerts.dispose();
    drills.dispose();
    guardians.dispose();
    super.dispose();
  }
}
