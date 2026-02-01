import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class LocalStorage {
  static const _keyLoggedIn = "logged_in";
  static const _keyTasks = "tasks";


  Future<void> saveLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyLoggedIn, true);
  }


  Future<void> clearLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyLoggedIn);
  }


  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyLoggedIn) ?? false;
  }


  Future<void> saveTasks(List<Map<String, dynamic>> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTasks, jsonEncode(tasks));
  }


  Future<List<Map<String, dynamic>>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyTasks);


    if (raw == null) return [];


    final decoded = jsonDecode(raw) as List;
    return decoded.cast<Map<String, dynamic>>();
  }
}
