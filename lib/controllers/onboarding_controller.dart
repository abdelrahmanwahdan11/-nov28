import 'dart:async';

import 'package:flutter/material.dart';

import '../core/services/shared_prefs_service.dart';

class OnboardingController {
  OnboardingController(this._prefs);

  final SharedPrefsService _prefs;
  final PageController pageController = PageController();
  final ValueNotifier<int> pageIndex = ValueNotifier(0);
  Timer? _timer;

  void startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      final next = (pageIndex.value + 1) % 3;
      pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
      pageIndex.value = next;
    });
  }

  void onPageChanged(int index) {
    pageIndex.value = index;
  }

  Future<void> completeOnboarding() async {
    await _prefs.setBool('has_seen_onboarding', true);
  }

  void dispose() {
    _timer?.cancel();
    pageController.dispose();
  }
}
