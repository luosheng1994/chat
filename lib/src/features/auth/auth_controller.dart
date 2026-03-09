import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  bool _isLoggedIn = true;
  ThemeMode _themeMode = ThemeMode.light;

  bool get isLoggedIn => _isLoggedIn;
  ThemeMode get themeMode => _themeMode;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
