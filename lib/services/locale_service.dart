import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LocaleService {
  static const String _boxName = 'settings';
  static const String _localeKey = 'locale';
  
  Box? _box;

  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  Locale getCurrentLocale() {
    final localeCode = _box?.get(_localeKey, defaultValue: 'en') as String? ?? 'en';
    return Locale(localeCode);
  }

  Future<void> setLocale(String localeCode) async {
    await _box?.put(_localeKey, localeCode);
  }

  bool get isArabic => getCurrentLocale().languageCode == 'ar';
  bool get isDarkMode => _box?.get('darkMode', defaultValue: true) as bool? ?? true;

  Future<void> setDarkMode(bool value) async {
    await _box?.put('darkMode', value);
  }
}
