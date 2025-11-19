import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/mock_data/mock_data.dart';

class CommunityController extends ChangeNotifier {
  CommunityController() {
    refresh();
  }

  final ValueNotifier<List<Map<String, dynamic>>> moments =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<List<Map<String, dynamic>>> mentors =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<List<Map<String, dynamic>>> circles =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  Future<void> refresh() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 520));
    final seed = DateTime.now().millisecondsSinceEpoch +
        Random().nextInt(55);
    moments.value = MockData.communityMoments(seed);
    mentors.value = MockData.communityMentors(seed);
    circles.value = MockData.communityCircles(seed);
    isLoading.value = false;
  }

  void toggleClap(String id) {
    moments.value = moments.value
        .map(
          (moment) => moment['id'] == id
              ? {
                  ...moment,
                  'claps': (moment['claps'] as int? ?? 0) + 1,
                }
              : moment,
        )
        .toList();
  }

  void toggleCircle(String id) {
    circles.value = circles.value
        .map(
          (circle) => circle['id'] == id
              ? {
                  ...circle,
                  'joined': !(circle['joined'] as bool? ?? false),
                }
              : circle,
        )
        .toList();
  }

  @override
  void dispose() {
    moments.dispose();
    mentors.dispose();
    circles.dispose();
    isLoading.dispose();
    super.dispose();
  }
}
