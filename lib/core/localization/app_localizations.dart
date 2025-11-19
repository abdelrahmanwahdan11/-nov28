import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('ar')];

  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'app_name': 'Health AI Checkup',
      'nav_home': 'Home',
      'nav_dashboard': 'Dashboard',
      'nav_checkup': 'Checkup',
      'nav_catalog': 'Catalog',
      'nav_profile': 'Profile',
      'drawer_about': 'About',
      'drawer_privacy': 'Privacy',
      'greeting_ready': 'Ready for your next checkup?',
      'emergency': 'Emergency',
      'call_emergency': 'Call emergency',
      'health_score': 'Health score',
      'pull_refresh': 'Pull to refresh',
      'daily_highlights': 'Daily highlights',
      'dashboard_title': 'Health Dashboard',
      'ai_info_placeholder': 'AI description coming soon.',
      'device_checkup': 'Device Checkup',
      'ai_checkup': 'AI Checkup',
      'run_full_scan': 'RUN FULL HEALTH SCAN',
      'continue': 'Continue',
      'selected_symptoms': 'Selected symptoms',
      'reports': 'Reports',
      'view_report': 'View report',
      'catalog_search_hint': 'Search devices, vitals, tips',
      'filters': 'Filters',
      'add_compare': 'Add to compare',
      'compare': 'Compare',
      'empty_compare': 'Add at least two items to compare.',
      'go_to_catalog': 'Go to catalog',
      'settings': 'Settings',
      'dark_mode': 'Dark mode',
      'primary_color': 'Primary color',
      'language': 'Language',
      'notifications': 'Notifications',
      'profile_greeting': 'Hello',
      'bmi': 'BMI',
      'search': 'Search',
      'make_measurement': 'MAKE MEASUREMENT',
      'load_more': 'Load older days',
      'guest': 'Continue as guest',
      'login': 'Login',
      'signup': 'Sign up',
      'email': 'Email',
      'password': 'Password',
      'forgot_password': 'Forgot password?',
      'password_strength': 'Password strength',
      'done': 'Done',
      'skip': 'Skip',
      'next': 'Next',
      'reports_status': 'Status',
      'global_search': 'Global search',
    },
    'ar': {
      'app_name': 'فحص الصحة بالذكاء الاصطناعي',
      'nav_home': 'الرئيسية',
      'nav_dashboard': 'لوحة الصحة',
      'nav_checkup': 'الفحص',
      'nav_catalog': 'الدليل',
      'nav_profile': 'الملف',
      'drawer_about': 'حول',
      'drawer_privacy': 'الخصوصية',
      'greeting_ready': 'هل أنت مستعد للفحص القادم؟',
      'emergency': 'طوارئ',
      'call_emergency': 'اتصال بالطوارئ',
      'health_score': 'درجة الصحة',
      'pull_refresh': 'اسحب للتحديث',
      'daily_highlights': 'أهم مهام اليوم',
      'dashboard_title': 'لوحة الصحة',
      'ai_info_placeholder': 'وصف الذكاء الاصطناعي قريباً.',
      'device_checkup': 'فحص الجهاز',
      'ai_checkup': 'فحص بالذكاء الاصطناعي',
      'run_full_scan': 'ابدأ الفحص الشامل',
      'continue': 'استمرار',
      'selected_symptoms': 'الأعراض المختارة',
      'reports': 'التقارير',
      'view_report': 'عرض التقرير',
      'catalog_search_hint': 'ابحث عن الأجهزة أو المؤشرات أو النصائح',
      'filters': 'المرشحات',
      'add_compare': 'أضف للمقارنة',
      'compare': 'المقارنة',
      'empty_compare': 'أضف عنصرين على الأقل للمقارنة',
      'go_to_catalog': 'اذهب إلى الدليل',
      'settings': 'الإعدادات',
      'dark_mode': 'الوضع الداكن',
      'primary_color': 'اللون الرئيسي',
      'language': 'اللغة',
      'notifications': 'الإشعارات',
      'profile_greeting': 'مرحباً',
      'bmi': 'مؤشر كتلة الجسم',
      'search': 'بحث',
      'make_measurement': 'ابدأ القياس',
      'load_more': 'تحميل أيام سابقة',
      'guest': 'الدخول كضيف',
      'login': 'تسجيل الدخول',
      'signup': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'forgot_password': 'نسيت كلمة المرور؟',
      'password_strength': 'قوة كلمة المرور',
      'done': 'تم',
      'skip': 'تخطي',
      'next': 'التالي',
      'reports_status': 'الحالة',
      'global_search': 'بحث شامل',
    }
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class _AppLocDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocDelegate old) => false;
}
