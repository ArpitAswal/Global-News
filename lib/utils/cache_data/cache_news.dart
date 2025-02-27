import 'dart:convert';

import '../preference_data/news_preference.dart';

class CacheNewsData {
  static final CacheNewsData _instance =
      CacheNewsData._internal(); // Singleton instance
  CacheNewsData._internal(); // Private constructor
  factory CacheNewsData() => _instance; // Factory constructor

  Map<String, dynamic>? getCacheCountryNews(String country) {
    String? cachedData = NewsPreference().fetchStringData(country);
    if (cachedData != null) {
      return jsonDecode(cachedData); // Return cached data
    }
    return null;
  }
}
