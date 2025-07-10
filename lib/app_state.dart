import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  String _currentLang = 'en'; // Padrão
  bool _isLoading = true;

  String get currentLang => _currentLang;
  bool get isLoading => _isLoading;

  AppState() {
    _loadLang();
  }

  Future<void> _loadLang() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLang = prefs.getString('preferredLang') ?? 'en';
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setLang(String langCode) async {
    _currentLang = langCode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('preferredLang', langCode);
  }
}
