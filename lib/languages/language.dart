import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Language {
  static Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    // ... app-specific localization delegate[s] here
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static Iterable<Locale> supportedLocales = [
    const Locale('en', 'US'), // English
    const Locale('es', 'ES'), // Spnish
    const Locale.fromSubtags(
        languageCode: 'zh'), // Chinese *See Advanced Locales below*
    // ... other locales the app supports
  ];
}
