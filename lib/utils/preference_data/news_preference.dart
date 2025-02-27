import 'package:shared_preferences/shared_preferences.dart';

class NewsPreference {
  static final NewsPreference _instance = NewsPreference._internal();
  SharedPreferences? _prefs; // Store prefs as a static variable

  NewsPreference._internal();

  factory NewsPreference() => _instance;

  /// Ensure SharedPreferences is initialized only once
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> saveStringData(String key, String data) async {
    await _prefs!.setString(key, data);
  }

  String? fetchStringData(String key) {
    return _prefs!.getString(key);
  }

  Future<void> saveListData(String key, List<String> data) async {
    await _prefs!.setStringList(key, data);
  }

  void removeStringData(String key) {
    _prefs!.remove(key);
  }

  List<String>? fetchListData(String key) {
    return _prefs!.getStringList(key);
  }
}
