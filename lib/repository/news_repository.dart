import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:global_news/models/chat_model.dart';
import 'package:global_news/models/chat_response_model.dart';
import 'package:http/http.dart' as http;

import '../exceptions/api_exception.dart';
import '../exceptions/app_exception.dart';

class NewsRepository {
  final String _apiKey = "news_api_key";
  final String _geminiAPIKey = "gemini_account_api_key";

  Future<ChatResponseModel?> geminiAPI({required List<Contents> messages}) async {
    final String apiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_geminiAPIKey';

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
        debugPrint('Error: ${res.statusCode} - ${res.reasonPhrase}');
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


  Future<dynamic> fetchCountryNews({required String country, required int dataSize}) async {
    try {
      String newsUrl =
            "https://newsapi.org/v2/everything?apiKey=$_apiKey&q=$country&pageSize=$dataSize";
      final response = await http.get(Uri.parse(newsUrl));
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

  Future<dynamic> fetchCategoryCountryBased(
      {required String category,
      required String country,
      required int dataSize}) async {
    try {
      String newsUrl =
          'https://newsapi.org/v2/everything?apiKey=$_apiKey&pageSize=$dataSize&q=("$category" AND "$country")';
      final response = await http.get(Uri.parse(newsUrl));
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

  Future<dynamic> fetchCountryTopHeadlines( {required String countryCode, required int dataSize}) async {
    try {
      String url =
            "https://newsapi.org/v2/top-headlines?apiKey=$_apiKey&country=$countryCode&pageSize=$dataSize";
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

  Future<dynamic> searchQueryNews({required String q, required int size}) async{
    try {
      String url =
          "https://newsapi.org/v2/everything?apiKey=$_apiKey&q=$q&pageSize=$size";
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
