import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  String _currentLang = 'en'; // Padrão
  ThemeMode _themeMode = ThemeMode.light;
  bool _isLoading = true;

  String get currentLang => _currentLang;
  ThemeMode get themeMode => _themeMode;
  bool get isLoading => _isLoading;

  AppState() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLang = prefs.getString('preferredLang') ?? 'en';
    final theme = prefs.getString('themeMode') ?? 'light';
    _themeMode = theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setLang(String langCode) async {
    _currentLang = langCode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('preferredLang', langCode);
  }

  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'themeMode', _themeMode == ThemeMode.dark ? 'dark' : 'light');
  }
}
