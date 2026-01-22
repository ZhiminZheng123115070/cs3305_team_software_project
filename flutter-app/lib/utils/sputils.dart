import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SPUtil {
  // Create factory method
  static SPUtil? _instance;

  factory SPUtil() => _instance ??= SPUtil._initial();
  SharedPreferences? _preferences;

  // Create named constructor
  SPUtil._initial() {
    // Why we need to write a new init method here: mainly because async/await cannot be used in named constructors
    init();
  }

  // Initialize SharedPreferences
  void init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  // Not done yet: sometimes you may encounter a prompt that SharedPreferences is not initialized when using it, so we also need to provide a static method
  static Future<SPUtil?> perInit() async {
    if (_instance == null) {
      // Static methods cannot access non-static variables, so we need to create a variable and then assign it back through a method
      SharedPreferences preferences = await SharedPreferences.getInstance();
      _instance = SPUtil._pre(preferences);
    }
    return _instance;
  }

  SPUtil._pre(SharedPreferences prefs) {
    _preferences = prefs;
  }

  /// Set String type
  void setString(key, value) {
    _preferences?.setString(key, value);
  }

  /// Set StringList type
  void setStringList(key, value) {
    _preferences?.setStringList(key, value);
  }

  /// Set Bool type
  void setBool(key, value) {
    _preferences?.setBool(key, value);
  }

  /// Set Double type
  void setDouble(key, value) {
    _preferences?.setDouble(key, value);
  }

  /// Set Int type
  void setInt(key, value) {
    _preferences?.setInt(key, value);
  }

  /// Store JSON type
  void setJson(key, value) {
    value = jsonEncode(value);
    _preferences?.setString(key, value);
  }

  /// Get data through generics
  T? get<T>(key) {
    var result = _preferences?.get(key);
    if (result != null) {
      return result as T;
    }
    return null;
  }

  /// Get JSON
  Map<String, dynamic>? getJson(key) {
    String? result = _preferences?.getString(key);
    if (result!.isNotEmpty) {
      return jsonDecode(result);
    }
    return null;
  }

  /// The isNotEmpty judgment in StringUtil in the text
  ///  static isNotEmpty(String? str) {
  /// return str?.isNotEmpty ?? false;
  /// }
  /// Clear all
  void clean() {
    _preferences?.clear();
  }

  /// Remove one
  void remove(key) {
    _preferences?.remove(key);
  }
}
