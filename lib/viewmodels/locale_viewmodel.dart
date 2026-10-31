import 'package:flutter/material.dart';

class LocaleViewModel extends ChangeNotifier {
  Locale _currentLocale = const Locale('en', 'US');

  Locale get currentLocale => _currentLocale;

  bool get isHindi => _currentLocale.languageCode == 'hi';

  String get currentLanguageName => isHindi ? 'हिंदी' : 'English';

  String get currentLanguageFlag => isHindi ? '🇮🇳' : '🇬🇧';

  void setLocale(Locale locale) {
    if (_currentLocale.languageCode != locale.languageCode) {
      _currentLocale = locale;
      notifyListeners();
    }
  }

  void toggleLanguage() {
    if (isHindi) {
      setLocale(const Locale('en', 'US'));
    } else {
      setLocale(const Locale('hi', 'IN'));
    }
  }
}
