import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/user.dart';

class UserService {
  static const String _userKey = 'current_user';
  static const String _loginStatusKey = 'is_logged_in';

  /// Authenticate user via DummyJSON auth endpoint and save data to SharedPreferences
  Future<User> login(String username, String password) async {
    final uri = Uri.parse('$host/auth/login');
    final response = await post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username.trim(),
        'password': password.trim(),
      }),
    );

    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final user = User.fromJson(data);
      await saveUser(user);
      return user;
    } else {
      final message = data['message'] ?? 'Invalid username or password';
      throw Exception(message);
    }
  }

  /// Save user data in SharedPreferences
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setBool(_loginStatusKey, true);
  }

  /// Retrieve currently saved user from SharedPreferences
  Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString(_userKey);
    if (userStr == null || userStr.isEmpty) return null;

    try {
      final Map<String, dynamic> data = jsonDecode(userStr);
      return User.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final user = await getSavedUser();
    return user != null;
  }

  /// Clear saved user data on sign out
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.setBool(_loginStatusKey, false);
  }

  /// Fetch user profile by ID from DummyJSON
  Future<User> getUserById(int id) async {
    final uri = Uri.parse('$host/users/$id');
    final response = await get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to load user: ${response.statusCode}');
    }
  }

  /// Fetch all users from DummyJSON
  Future<List<User>> getAllUsers() async {
    try {
      final uri = Uri.parse('$host/users?limit=0');
      final response = await get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List list = data['users'] ?? [];
        return list
            .map((u) => User.fromJson(u as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {}
    return [];
  }
}
