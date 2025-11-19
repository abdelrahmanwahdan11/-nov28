import 'package:flutter/material.dart';

import '../core/mock_data/mock_data.dart';

class ProfileController {
  final ValueNotifier<Map<String, dynamic>> profile =
      ValueNotifier(MockData.userProfile);

  double get bmi {
    final weight = profile.value['weightKg'] as num;
    final height = (profile.value['heightCm'] as num) / 100;
    return weight / (height * height);
  }
}
