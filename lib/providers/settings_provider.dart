import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsProvider with ChangeNotifier {
  final Box _settings = Hive.box('settings');

  bool get isDarkMode => _settings.get('isDarkMode', defaultValue: true);
  String get language => _settings.get('language', defaultValue: 'en');

  void setDarkMode(bool value) {
    _settings.put('isDarkMode', value);
    notifyListeners();
  }

  void setLanguage(String lang) {
    _settings.put('language', lang);
    notifyListeners();
  }

  void loadSettings() {
    notifyListeners();
  }
}
