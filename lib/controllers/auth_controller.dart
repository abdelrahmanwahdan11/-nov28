import 'package:flutter/material.dart';

import '../core/services/shared_prefs_service.dart';

class AuthController {
  AuthController(this._prefs);

  final SharedPrefsService _prefs;
  final GlobalKey<FormState> loginKey = GlobalKey();
  final GlobalKey<FormState> signupKey = GlobalKey();
  final TextEditingController loginEmail = TextEditingController();
  final TextEditingController loginPassword = TextEditingController();
  final TextEditingController signupEmail = TextEditingController();
  final TextEditingController signupPassword = TextEditingController();
  final ValueNotifier<bool> isGuest = ValueNotifier(false);
  final ValueNotifier<bool> obscureLogin = ValueNotifier(true);
  final ValueNotifier<bool> obscureSignup = ValueNotifier(true);

  String passwordStrengthLabel(String password) {
    if (password.length >= 12) return 'Strong';
    if (password.length >= 8) return 'Medium';
    return 'Weak';
  }

  Color passwordStrengthColor(String password) {
    final label = passwordStrengthLabel(password);
    switch (label) {
      case 'Strong':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  Future<void> continueAsGuest() async {
    isGuest.value = true;
    await _prefs.setBool('guest_mode', true);
  }

  Future<void> markSignedIn() async {
    isGuest.value = false;
    await _prefs.setBool('guest_mode', false);
  }
}
