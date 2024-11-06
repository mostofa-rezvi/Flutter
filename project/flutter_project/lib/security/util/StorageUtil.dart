import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageUtil {

  // Save data to local storage
  static Future<void> saveToLocalStorage(String key, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, jsonEncode(data)); // Convert data to JSON string
  }

  // Retrieve data from local storage
  static Future<dynamic> getFromLocalStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    return data != null ? jsonDecode(data) : null;
  }

  // Remove data from local storage
  static Future<void> removeFromLocalStorage(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
