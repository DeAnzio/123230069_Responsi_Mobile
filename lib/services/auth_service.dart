import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _loggedInKey = 'is_logged_in';
  static const _usernameKey = 'username';

  static Box get _usersBox => Hive.box('users');

  static String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  static Future<bool> register(String username, String password) async {
    final normalizedUsername = username.trim();
    if (_usersBox.containsKey(normalizedUsername)) {
      return false;
    }

    await _usersBox.put(normalizedUsername, {
      'username': normalizedUsername,
      'passwordHash': _hashPassword(password),
    });
    return true;
  }

  static Future<bool> login(String username, String password) async {
    final normalizedUsername = username.trim();
    final user = _usersBox.get(normalizedUsername);

    if (user == null) {
      return false;
    }

    final userMap = Map<String, dynamic>.from(user as Map);
    final isPasswordValid =
        userMap['passwordHash'] == _hashPassword(password.trim());

    if (!isPasswordValid) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, true);
    await prefs.setString(_usernameKey, normalizedUsername);
    return true;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn = prefs.getBool(_loggedInKey) ?? false;
    final username = prefs.getString(_usernameKey);

    if (!loggedIn || username == null) {
      return false;
    }

    return _usersBox.containsKey(username);
  }

  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey) ?? '';
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
    await prefs.remove(_usernameKey);
  }
}
