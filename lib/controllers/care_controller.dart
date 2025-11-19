import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/mock_data/mock_data.dart';

class CareController extends ChangeNotifier {
  CareController() {
    refresh();
  }

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<List<Map<String, dynamic>>> careTeam =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<List<Map<String, dynamic>>> tickets =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<List<Map<String, dynamic>>> carePlan =
      ValueNotifier<List<Map<String, dynamic>>>(const []);
  final ValueNotifier<String> selectedChannel =
      ValueNotifier<String>('video');

  Future<void> refresh() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 540));
    final seed = DateTime.now().millisecondsSinceEpoch + Random().nextInt(88);
    careTeam.value = MockData.careTeamMembers(seed);
    tickets.value = MockData.careTickets(seed);
    carePlan.value = MockData.carePlans(seed);
    isLoading.value = false;
  }

  void toggleFavorite(String id) {
    final updated = careTeam.value
        .map(
          (member) => member['id'] == id
              ? {
                  ...member,
                  'favorite': !(member['favorite'] as bool? ?? false),
                }
              : member,
        )
        .toList();
    careTeam.value = updated;
  }

  void closeTicket(String id) {
    final updated = tickets.value
        .map(
          (ticket) => ticket['id'] == id
              ? {
                  ...ticket,
                  'status': 'closed',
                }
              : ticket,
        )
        .toList();
    tickets.value = updated;
  }

  void togglePlanStep(String id) {
    final updated = carePlan.value
        .map(
          (step) => step['id'] == id
              ? {
                  ...step,
                  'completed': !(step['completed'] as bool? ?? false),
                }
              : step,
        )
        .toList();
    carePlan.value = updated;
  }

  void setChannel(String channel) {
    selectedChannel.value = channel;
  }

  @override
  void dispose() {
    isLoading.dispose();
    careTeam.dispose();
    tickets.dispose();
    carePlan.dispose();
    selectedChannel.dispose();
    super.dispose();
  }
}
