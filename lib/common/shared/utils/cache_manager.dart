import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static late SharedPreferences _preferences;
  static const _secureStorage = FlutterSecureStorage();

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Locale? get locale {
    final value = _preferences.getString('locale');

    if (value == null) {
      return null;
    }

    return Locale(value);
  }

  static Future<dynamic> getData(String key) async {
    final value = _preferences.getString(key);
    return value;
  }

  static void changeLocale(String locale) {
    _preferences.setString('locale', locale);
  }

  static Future<String?> getToken() async {
    final token = await _secureStorage.read(key: 'access_token');
    return token;
  }

  static Future<void> setToken(String token) async {
    await _secureStorage.write(
      key: 'access_token',
      value: token,
    );
  }

  static Future<void> saveData(String key, String value) async {
    _preferences.setString(key, value);
  }

  static Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'access_token');
  }
}
