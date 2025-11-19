import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/mock_data/mock_data.dart';

class RecoveryController extends ChangeNotifier {
  RecoveryController() {
    refresh();
  }

  final ValueNotifier<List<Map<String, dynamic>>> protocols =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<List<Map<String, dynamic>>> calmingMoments =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<List<Map<String, dynamic>>> breathStacks =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<double> resetScore = ValueNotifier<double>(8.0);

  Future<void> refresh() async {
    isLoading.value = true;
    final seed = DateTime.now().millisecondsSinceEpoch + Random().nextInt(99);
    await Future.delayed(const Duration(milliseconds: 540));
    protocols.value = MockData.recoveryProtocols(seed);
    calmingMoments.value = MockData.recoveryMoments(seed);
    breathStacks.value = MockData.breathStacks(seed);
    resetScore.value = (7 + Random(seed).nextDouble() * 2.5);
    isLoading.value = false;
  }

  void toggleProtocol(String id) {
    protocols.value = protocols.value
        .map(
          (protocol) => protocol['id'] == id
              ? {
                  ...protocol,
                  'completed': !(protocol['completed'] as bool? ?? false),
                }
              : protocol,
        )
        .toList();
  }

  void toggleMoment(String id) {
    calmingMoments.value = calmingMoments.value
        .map(
          (moment) => moment['id'] == id
              ? {
                  ...moment,
                  'favorite': !(moment['favorite'] as bool? ?? false),
                }
              : moment,
        )
        .toList();
  }

  void toggleBreath(String id) {
    breathStacks.value = breathStacks.value
        .map(
          (stack) => stack['id'] == id
              ? {
                  ...stack,
                  'completed': !(stack['completed'] as bool? ?? false),
                }
              : stack,
        )
        .toList();
  }

  @override
  void dispose() {
    protocols.dispose();
    calmingMoments.dispose();
    breathStacks.dispose();
    isLoading.dispose();
    resetScore.dispose();
    super.dispose();
  }
}
