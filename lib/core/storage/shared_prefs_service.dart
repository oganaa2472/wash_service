import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class SharedPrefsService {
  final SharedPreferences _prefs;

  SharedPrefsService(this._prefs);

  // Auth Token
  Future<bool> setAuthToken(String token) async {
    return await _prefs.setString(AppConstants.authTokenKey, token);
  }

  String? getAuthToken() {
    return _prefs.getString(AppConstants.authTokenKey);
  }

  Future<bool> removeAuthToken() async {
    return await _prefs.remove(AppConstants.authTokenKey);
  }

  // User Data
  Future<bool> setUserData(String userData) async {
    return await _prefs.setString('user_data', userData);
  }

  String? getUserData() {
    return _prefs.getString('user_data');
  }

  Future<bool> removeUserData() async {
    return await _prefs.remove('user_data');
  }

  // Theme Mode
  Future<bool> setIsDarkMode(bool isDarkMode) async {
    return await _prefs.setBool('is_dark_mode', isDarkMode);
  }

  bool getIsDarkMode() {
    return _prefs.getBool('is_dark_mode') ?? false;
  }

  // Language
  Future<bool> setLanguage(String languageCode) async {
    return await _prefs.setString('language_code', languageCode);
  }

  String getLanguage() {
    return _prefs.getString('language_code') ?? 'en';
  }

  // App Settings
  Future<bool> setNotificationsEnabled(bool enabled) async {
    return await _prefs.setBool('notifications_enabled', enabled);
  }

  bool getNotificationsEnabled() {
    return _prefs.getBool('notifications_enabled') ?? true;
  }

  // Clear all data
  Future<bool> clearAll() async {
    return await _prefs.clear();
  }
} 