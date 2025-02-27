import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:global_news/models/chat_model.dart';
import 'package:global_news/models/chat_response_model.dart';
import 'package:global_news/utils/config/app_keys.dart';
import 'package:global_news/utils/preference_data/news_preference.dart';
import 'package:http/http.dart' as http;

import '../exceptions/api_exception.dart';
import '../exceptions/app_exception.dart';
import '../utils/cache_data/cache_news.dart';

class NewsRepository {
  final String _newsKeys = AppKeys.newsKey;
  final String _geminiKey = AppKeys.geminiKey;
  late NewsPreference prefs;
  late CacheNewsData cache;

  NewsRepository._internal(); //  prevents direct instantiation from outside, so we force developers to always use create().

  static Future<NewsRepository> create() async {
    // static because we don’t need an instance of NewsRepository to call it.
    return NewsRepository._internal()
      ..prefs = NewsPreference()
      ..cache = CacheNewsData();
  }

  Future<ChatResponseModel?> geminiAPI(
      {required List<Contents> messages}) async {
    final String apiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_geminiKey';

    try {
      // Build the payload
      final res = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': messages.map((e) => e.toJson()).toList(),
          'generationConfig': {
            'temperature': 0.5,
            'topK': 40,
            'topP': 1.0,
            'maxOutputTokens': 5026,
            'responseMimeType': 'text/plain',
          },
        }),
      );

      // Check if the request was successful
      if (res.statusCode == 200) {
        final responseData = jsonDecode(res.body);
        return ChatResponseModel.fromJson(responseData);
      } else {
        return null;
      }
    } on SocketException {
      throw AppException(
          message: 'No Internet connection', type: ExceptionType.internet);
    } on HttpException {
      throw AppException(
          message: "Couldn't find the data", type: ExceptionType.http);
    } on FormatException {
      throw AppException(
          message: "Bad response format", type: ExceptionType.format);
    } on TimeoutException catch (_) {
      throw AppException(
        message: 'Connection timed out',
        type: ExceptionType.timeout,
      );
    }
  }

  Future<dynamic> fetchCountryNews(
      {required String country, required bool initialCall}) async {
    try {
      String newsUrl =
          "https://newsapi.org/v2/everything?apiKey=$_newsKeys&q=$country";

      if (initialCall) {
        final response = await http.get(Uri.parse(newsUrl));
        final result = returnResponse(response);
        prefs.saveStringData('country_news_$country', response.body);
        return result;
      } else {
        final cachedData = cache.getCacheCountryNews('country_news_$country');
        return cachedData; // Return cached data
      }
    } on SocketException {
      throw AppException(
          message: 'No Internet connection', type: ExceptionType.internet);
    } on HttpException {
      throw AppException(
          message: "Couldn't find the data", type: ExceptionType.http);
    } on FormatException {
      throw AppException(
          message: "Bad response format", type: ExceptionType.format);
    } on TimeoutException catch (_) {
      throw AppException(
        message: 'Connection timed out',
        type: ExceptionType.timeout,
      );
    }
  }

  Future<dynamic> fetchCategoryCountryBased(
      {required String category,
      required String country,
      required bool refresh}) async {
    try {
      String newsUrl =
          'https://newsapi.org/v2/everything?apiKey=$_newsKeys&q=("$category" AND "$country")';
      final cachedData =
          cache.getCacheCountryNews('country_category_news_$country&$category');
      // Get the existing list or create a new one if it doesn't exist
      List<String> catList = prefs.fetchListData("categories_saved") ?? [];
      if (!catList.contains("$country&$category") || refresh) {
        catList.add("$country&$category");
        final response = await http.get(Uri.parse(newsUrl));
        final result = returnResponse(response);
        prefs.saveStringData(
            'country_category_news_$country&$category', response.body);
        prefs.saveListData('categories_saved', catList);
        return result;
      } else {
        return cachedData; // Return cached data
      }
    } on SocketException {
      throw AppException(
          message: 'No Internet connection', type: ExceptionType.internet);
    } on HttpException {
      throw AppException(
          message: "Couldn't find the data", type: ExceptionType.http);
    } on FormatException {
      throw AppException(
          message: "Bad response format", type: ExceptionType.format);
    } on TimeoutException catch (_) {
      throw AppException(
        message: 'Connection timed out',
        type: ExceptionType.timeout,
      );
    }
  }

  Future<dynamic> fetchCountryTopHeadlines(
      {required String countryCode, required bool initialCall}) async {
    try {
      String url =
          "https://newsapi.org/v2/top-headlines?apiKey=$_newsKeys&country=$countryCode";
      if (initialCall) {
        final response = await http.get(Uri.parse(url));
        final result = returnResponse(response);
        prefs.saveStringData('headlines_news_$countryCode', response.body);
        return result;
      } else {
        final cachedData =
            cache.getCacheCountryNews('headlines_news_$countryCode');
        return cachedData; // Return cached data
      }
    } on SocketException {
      throw AppException(
          message: 'No Internet connection', type: ExceptionType.internet);
    } on HttpException {
      throw AppException(
          message: "Couldn't find the data", type: ExceptionType.http);
    } on FormatException {
      throw AppException(
          message: "Bad response format", type: ExceptionType.format);
    } on TimeoutException catch (_) {
      throw AppException(
        message: 'Connection timed out',
        type: ExceptionType.timeout,
      );
    }
  }

  Future<dynamic> searchQueryNews({required String query}) async {
    try {
      String url =
          "https://newsapi.org/v2/everything?apiKey=$_newsKeys&q=$query";
      final response = await http.get(Uri.parse(url));
      return returnResponse(response);
    } on SocketException {
      throw AppException(
          message: 'No Internet connection', type: ExceptionType.internet);
    } on HttpException {
      throw AppException(
          message: "Couldn't find the data", type: ExceptionType.http);
    } on FormatException {
      throw AppException(
          message: "Bad response format", type: ExceptionType.format);
    } on TimeoutException catch (_) {
      throw AppException(
        message: 'Connection timed out',
        type: ExceptionType.timeout,
      );
    }
  }
}
